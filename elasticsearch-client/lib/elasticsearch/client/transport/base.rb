module Elasticsearch
  module Client
    module Transport
      module Base
        DEFAULT_PORT             = 9200
        DEFAULT_PROTOCOL         = 'http'
        DEFAULT_RELOAD_AFTER     = 10_000 # Requests
        DEFAULT_RESURRECT_AFTER  = 60     # Seconds
        DEFAULT_MAX_TRIES        = 3      # Requests
        DEFAULT_SERIALIZER_CLASS = Serializer::MultiJson

        attr_reader   :hosts, :options, :connections, :counter, :last_request_at, :protocol
        attr_accessor :serializer, :sniffer, :logger, :tracer, :reload_after, :resurrect_after, :max_tries

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

        def get_connection(options={})
          resurrect_dead_connections! if Time.now > @last_request_at + @resurrect_after

          connection = connections.get_connection(options)
          @counter  += 1

          reload_connections!         if @options[:reload_connections] && counter % reload_after == 0
          connection
        end

        def reload_connections!
          hosts = sniffer.hosts
          __rebuild_connections :hosts => hosts, :options => options
          self
        rescue SnifferTimeoutError
          logger.error "[SnifferTimeoutError] Timeout when reloading connections." if logger
          self
        end

        def resurrect_dead_connections!
          connections.dead.each { |c| c.resurrect! }
        end

        def __rebuild_connections(arguments={})
          @hosts       = arguments[:hosts]    || []
          @options     = arguments[:options]  || {}
          @connections = __build_connections
        end

        def __log(method, path, params, body, url, response, json, took, duration)
          logger.info  "#{method.to_s.upcase} #{url} " +
                       "[status:#{response.status}, request:#{sprintf('%.3fs', duration)}, query:#{took}]"
          logger.debug "> #{serializer.dump(body)}" if body
          logger.debug "< #{response.body}"
        end

        def __log_failed(response)
          logger.fatal "[#{response.status}] #{response.body}"
        end

        def __trace(method, path, params, body, url, response, json, took, duration)
          trace_url  = "http://localhost:9200/#{path}?pretty" +
                       ( params.empty? ? '' : "&#{::Faraday::Utils::ParamsHash[params].to_query}" )
          trace_body = body ? " -d '#{serializer.dump(body, :pretty => true)}'" : ''
          tracer.info  "curl -X #{method.to_s.upcase} '#{trace_url}'#{trace_body}\n"
          tracer.debug "# #{Time.now.iso8601} [#{response.status}] (#{format('%.3f', duration)}s)\n#"
          tracer.debug json ? serializer.dump(json, :pretty => true).gsub(/^/, '# ').sub(/\}$/, "\n# }")+"\n" : "# #{response.body}\n"
        end

        def perform_request(method, path, params={}, body=nil, &block)
          raise NoMethodError, "Implement this method in your transport class" unless block_given?
          start = Time.now if logger || tracer
          tries = 0

          begin
            tries     += 1
            connection = get_connection or raise Error.new("Cannot get new connection from pool.")
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

          json     = serializer.load(response.body) if response.body.to_s =~ /^\{/
          took     = (json['took'] ? sprintf('%.3fs', json['took']/1000.0) : 'n/a') rescue 'n/a' if logger || tracer
          duration = Time.now-start if logger || tracer

          __log   method, path, params, body, url, response, json, took, duration if logger
          __trace method, path, params, body, url, response, json, took, duration if tracer

          if response.status.to_i >= 500
            __log_failed response if logger
            raise ServerError.new("[#{response.status}] #{response.body}")
          else
            Response.new response.status, json || response.body, response.headers
          end
        ensure
          @last_request_at = Time.now
        end

        def host_unreachable_exceptions
          [Errno::ECONNREFUSED]
        end

        def __build_connections
          raise NoMethodError, "Implement this method in your class"
        end
      end
    end
  end
end
