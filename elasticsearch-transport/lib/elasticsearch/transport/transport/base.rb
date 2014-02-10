module Elasticsearch
  module Transport
    module Transport

      # @abstract Module with common functionality for transport implementations.
      #
      module Base
        DEFAULT_PORT             = 9200
        DEFAULT_PROTOCOL         = 'http'
        DEFAULT_RELOAD_AFTER     = 10_000 # Requests
        DEFAULT_RESURRECT_AFTER  = 60     # Seconds
        DEFAULT_MAX_TRIES        = 3      # Requests
        DEFAULT_SERIALIZER_CLASS = Serializer::MultiJson

        attr_reader   :hosts, :options, :connections, :counter, :last_request_at, :protocol
        attr_accessor :serializer, :sniffer, :logger, :tracer, :reload_after, :resurrect_after, :max_tries

        # Creates a new transport object.
        #
        # @param arguments [Hash] Settings and options for the transport
        # @param block     [Proc] Lambda or Proc which can be evaluated in the context of the "session" object
        #
        # @option arguments [Array] :hosts   An Array of normalized hosts information
        # @option arguments [Array] :options A Hash with options (usually passed by {Client})
        #
        # @see Client#initialize
        #
        def initialize(arguments={}, &block)
          @hosts       = arguments[:hosts]   || []
          @options     = arguments[:options] || {}
          @block       = block
          @connections = __build_connections

          @serializer  = options[:serializer] || ( options[:serializer_class] ? options[:serializer_class].new(self) : DEFAULT_SERIALIZER_CLASS.new(self) )
          @protocol    = options[:protocol] || DEFAULT_PROTOCOL

          @logger      = options[:logger]
          @tracer      = options[:tracer]

          @sniffer     = options[:sniffer_class] ? options[:sniffer_class].new(self) : Sniffer.new(self)
          @counter     = 0
          @last_request_at = Time.now
          @reload_after    = options[:reload_connections].is_a?(Fixnum) ? options[:reload_connections] : DEFAULT_RELOAD_AFTER
          @resurrect_after = options[:resurrect_after] || DEFAULT_RESURRECT_AFTER
          @max_tries       = options[:retry_on_failure].is_a?(Fixnum)   ? options[:retry_on_failure]   : DEFAULT_MAX_TRIES
        end

        # Returns a connection from the connection pool by delegating to {Connections::Collection#get_connection}.
        #
        # Resurrects dead connection if the `resurrect_after` timeout has passed.
        # Increments the counter and performs connection reloading if the `reload_connections` option is set.
        #
        # @return [Connections::Connection]
        # @see    Connections::Collection#get_connection
        #
        def get_connection(options={})
          resurrect_dead_connections! if Time.now > @last_request_at + @resurrect_after

          connection = connections.get_connection(options)
          @counter  += 1

          reload_connections!         if @options[:reload_connections] && counter % reload_after == 0
          connection
        end

        # Reloads and replaces the connection collection based on cluster information.
        #
        # @see Sniffer#hosts
        #
        def reload_connections!
          hosts = sniffer.hosts
          __rebuild_connections :hosts => hosts, :options => options
          self
        rescue SnifferTimeoutError
          logger.error "[SnifferTimeoutError] Timeout when reloading connections." if logger
          self
        end

        # Tries to "resurrect" all eligible dead connections.
        #
        # @see Connections::Connection#resurrect!
        #
        def resurrect_dead_connections!
          connections.dead.each { |c| c.resurrect! }
        end

        # Replaces the connections collection.
        #
        # @api private
        #
        def __rebuild_connections(arguments={})
          @hosts       = arguments[:hosts]    || []
          @options     = arguments[:options]  || {}
          @connections = __build_connections
        end

        # Log request and response information.
        #
        # @api private
        #
        def __log(method, path, params, body, url, response, json, took, duration)
          logger.info  "#{method.to_s.upcase} #{url} " +
                       "[status:#{response.status}, request:#{sprintf('%.3fs', duration)}, query:#{took}]"
          logger.debug "> #{__convert_to_json(body)}" if body
          logger.debug "< #{response.body}"
        end

        # Log failed request.
        #
        # @api private
        def __log_failed(response)
          logger.fatal "[#{response.status}] #{response.body}"
        end

        # Trace the request in the `curl` format.
        #
        # @api private
        def __trace(method, path, params, body, url, response, json, took, duration)
          trace_url  = "http://localhost:9200/#{path}?pretty" +
                       ( params.empty? ? '' : "&#{::Faraday::Utils::ParamsHash[params].to_query}" )
          trace_body = body ? " -d '#{__convert_to_json(body, :pretty => true)}'" : ''
          tracer.info  "curl -X #{method.to_s.upcase} '#{trace_url}'#{trace_body}\n"
          tracer.debug "# #{Time.now.iso8601} [#{response.status}] (#{format('%.3f', duration)}s)\n#"
          tracer.debug json ? serializer.dump(json, :pretty => true).gsub(/^/, '# ').sub(/\}$/, "\n# }")+"\n" : "# #{response.body}\n"
        end

        # Raise error specific for the HTTP response status or a generic server error
        #
        # @api private
        def __raise_transport_error(response)
          error = ERRORS[response.status] || ServerError
          raise error.new "[#{response.status}] #{response.body}"
        end

        # Converts any non-String object to JSON
        #
        # @api private
        def __convert_to_json(o=nil, options={})
          o = o.is_a?(String) ? o : serializer.dump(o, options)
        end

        # Returns a full URL based on information from host
        #
        # @param host [Hash] Host configuration passed in from {Client}
        #
        # @api private
        def __full_url(host)
          url  = "#{host[:protocol]}://"
          url += "#{host[:user]}:#{host[:password]}@" if host[:user]
          url += "#{host[:host]}:#{host[:port]}"
          url += "#{host[:path]}" if host[:path]
          url
        end

        # Performs a request to Elasticsearch, while handling logging, tracing, marking dead connections,
        # retrying the request and reloading the connections.
        #
        # @abstract The transport implementation has to implement this method either in full,
        #           or by invoking this method with a block. See {HTTP::Faraday#perform_request} for an example.
        #
        # @param method [String] Request method
        # @param path   [String] The API endpoint
        # @param params [Hash]   Request parameters (will be serialized by {Connections::Connection#full_url})
        # @param body   [Hash]   Request body (will be serialized by the {#serializer})
        # @param block  [Proc]   Code block to evaluate, passed from the implementation
        #
        # @return [Response]
        # @raise  [NoMethodError] If no block is passed
        # @raise  [ServerError]   If request failed on server
        # @raise  [Error]         If no connection is available
        #
        def perform_request(method, path, params={}, body=nil, &block)
          raise NoMethodError, "Implement this method in your transport class" unless block_given?
          start = Time.now if logger || tracer
          tries = 0

          begin
            tries     += 1
            connection = get_connection or raise Error.new("Cannot get new connection from pool.")

            if connection.connection.respond_to?(:params) && connection.connection.params.respond_to?(:to_hash)
              params = connection.connection.params.merge(params.to_hash)
            end

            url        = connection.full_url(path, params)

            response   = block.call(connection, url)

            connection.healthy! if connection.failures > 0

          rescue *host_unreachable_exceptions => e
            logger.error "[#{e.class}] #{e.message} #{connection.host.inspect}" if logger

            connection.dead!

            if @options[:reload_on_failure] and tries < connections.all.size
              logger.warn "[#{e.class}] Reloading connections (attempt #{tries} of #{connections.size})" if logger
              reload_connections! and retry
            end

            if @options[:retry_on_failure]
              logger.warn "[#{e.class}] Attempt #{tries} connecting to #{connection.host.inspect}" if logger
              if tries < max_tries
                retry
              else
                logger.fatal "[#{e.class}] Cannot connect to #{connection.host.inspect} after #{tries} tries" if logger
                raise e
              end
            else
              raise e
            end

          rescue Exception => e
            logger.fatal "[#{e.class}] #{e.message} (#{connection.host.inspect})" if logger
            raise e
          end

          json     = serializer.load(response.body) if response.headers && response.headers["content-type"] =~ /json/
          took     = (json['took'] ? sprintf('%.3fs', json['took']/1000.0) : 'n/a') rescue 'n/a' if logger || tracer
          duration = Time.now-start if logger || tracer

          __log   method, path, params, body, url, response, json, took, duration if logger
          __trace method, path, params, body, url, response, json, took, duration if tracer

          if response.status.to_i >= 300
            __log_failed response if logger
            __raise_transport_error response
          else
            Response.new response.status, json || response.body, response.headers
          end
        ensure
          @last_request_at = Time.now
        end

        # @abstract Returns an Array of connection errors specific to the transport implementation.
        #           See {HTTP::Faraday#host_unreachable_exceptions} for an example.
        #
        # @return [Array]
        #
        def host_unreachable_exceptions
          [Errno::ECONNREFUSED]
        end

        # @abstract A transport implementation must implement this method.
        #           See {HTTP::Faraday#__build_connections} for an example.
        #
        # @return [Connections::Collection]
        # @api    private
        def __build_connections
          raise NoMethodError, "Implement this method in your class"
        end
      end
    end
  end
end
