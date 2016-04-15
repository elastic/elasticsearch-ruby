require 'manticore'
require "elasticsearch/transport/transport/http/manticore/pool"
require "elasticsearch/transport/transport/http/manticore/adapter"
require "elasticsearch/transport/transport/http/manticore/manticore_sniffer"

module Elasticsearch
  module Transport
    module Transport
      module HTTP
        # Alternative HTTP transport implementation for JRuby,
        # using the [_Manticore_](https://github.com/cheald/manticore) client,
        #
        # @example HTTP
        #
        #     require 'elasticsearch/transport/transport/http/manticore'
        #
        #     client = Elasticsearch::Client.new transport_class: Elasticsearch::Transport::Transport::HTTP::Manticore
        #
        #     client.transport.connections.first.connection
        #     => #<Manticore::Client:0x56bf7ca6 ...>
        #
        #     client.info['status']
        #     => 200
        #
        #  @example HTTPS (All SSL settings are optional,
        #                  see http://www.rubydoc.info/gems/manticore/Manticore/Client:initialize)
        #
        #     require 'elasticsearch/transport/transport/http/manticore'
        #
        #     client = Elasticsearch::Client.new \
        #       url: 'https://elasticsearch.example.com',
        #       transport_class: Elasticsearch::Transport::Transport::HTTP::Manticore,
        #       ssl: {
        #         truststore: '/tmp/truststore.jks',
        #         truststore_password: 'password',
        #         keystore: '/tmp/keystore.jks',
        #         keystore_password: 'secret',
        #       }
        #
        #     client.transport.connections.first.connection
        #     => #<Manticore::Client:0xdeadbeef ...>
        #
        #     client.info['status']
        #     => 200
        #
        # @see Transport::Base
        #
        class Manticore
          attr_reader :pool, :adapter, :options
          include Base

          def initialize(arguments={}, &block)
            @options = arguments[:options] || {}
            @options[:http] ||= {}
            @logger = options[:logger]
            @adapter = Adapter.new(logger, options)
            @healthcheck_path = options[:healthcheck_path] || "/"
            @pool = Manticore::Pool.new(logger, @adapter, @healthcheck_path, (arguments[:hosts] || []), 5, self.host_unreachable_exceptions, options)
            @protocol    = options[:protocol] || DEFAULT_PROTOCOL
            @serializer = options[:serializer] || ( options[:serializer_class] ? options[:serializer_class].new(self) : DEFAULT_SERIALIZER_CLASS.new(self) )
            @max_retries     = options[:retry_on_failure].is_a?(Fixnum)   ? options[:retry_on_failure]   : DEFAULT_MAX_RETRIES
            @retry_on_status = Array(options[:retry_on_status]).map { |d| d.to_i }

            setup_sniffing!
          end

          def setup_sniffing!
            if options[:sniffing] || options[:reload_connections]
              # We don't support sniffers that aren't threadsafe with timers here!
              sniffer_class = options[:sniffer_class] ? options[:sniffer_class] : ::Elasticsearch::Transport::Transport::HTTP::Manticore::ManticoreSniffer
              raise ArgumentError, "Sniffer class #{sniffer_class} must be a ManticoreSniffer!" if sniffer_class.nil? || !sniffer_class.ancestors.include?(::Elasticsearch::Transport::Transport::HTTP::Manticore::ManticoreSniffer)
              @sniffer = sniffer_class.new(self, logger)
              @sniffer.sniff_every(options[:sniffer_delay] || 5) do |urls|
                logger.info("Will update internal host pool with #{urls.inspect}")
                @pool.update_urls(urls)
              end
            end
          end

          # Sniff (if enabled) to get the newest list of hosts
          # then attempt to resurrect any dead URLs
          def reload_connections!
            if options[:sniffing]
              @pool.update_urls(@sniffer.hosts)
            end
            @pool.resurrect_dead!
          end

          def perform_request(method, path, params={}, body=nil)
            body = __convert_to_json(body) if body
            url, response = with_request_retries do
              url, response = @pool.perform_request(method, path, params, body)
              # Raise an exception so we can catch it for `retry_on_status`
              __raise_transport_error(response) if response.status.to_i >= 300 && @retry_on_status.include?(response.status.to_i)
              [url, response]
            end

            enrich_response(method, url, path, params, body, response)
          end

          # This takes a host string to aid in debug logging
          def with_request_retries
            tries = 0
            begin
              tries += 1
              yield
            rescue ::Elasticsearch::Transport::Transport::ServerError => e
              if @retry_on_status.include?(e.response.status)
                logger.warn "[#{e.class}] Attempt #{tries} to get response from #{url}" if logger
                logger.debug "[#{e.class}] Attempt #{tries} to get response from #{url}" if logger
                if tries <= max_retries
                  retry
                else
                  logger.error "[#{e.class}] Cannot get response from #{url} after #{tries} tries" if logger
                  raise e
                end
              else
                raise e
              end
            rescue ::Elasticsearch::Transport::Transport::HostUnreachableError => e
              logger.error "[#{e.class}] #{e.message} #{e.url}" if logger

              if @options[:retry_on_failure]
                logger.warn "[#{e.class}] Attempt #{tries} connecting to #{connection.host.inspect}" if logger
                if tries <= max_retries
                  if @options[:reload_on_failure] && pool.alive_urls_count == 0
                    logger.warn "[#{e.class}] Reloading connections (attempt #{tries} of #{max_retries})" if logger
                    reload_connections!
                  end

                  retry
                else
                  logger.fatal "[#{e.class}] Cannot connect to #{connection.host.inspect} after #{tries} tries" if logger
                  raise e
                end
              end
            rescue Exception => e
              logger.fatal "[#{e.class}] #{e.message} ()" if logger
              raise e
            end
          end

          def __close_connections
            if @sniffer
              logger.info("Closing sniffer...") if logger
              @sniffer.close
            end
            logger.info("Sniffer closed.") if logger
            logger.info("Closing pool") if logger
            @pool.close # closes adapter as well
            logger.info("Pool closed") if logger
          end

          def enrich_response(method, url, path, params, body, response)
            start = Time.now if logger || tracer

            duration = Time.now-start if logger || tracer

            if response.status.to_i >= 300
              __log    method, path, params, body, url, response, nil, 'N/A', duration if logger
              __trace  method, path, params, body, url, response, nil, 'N/A', duration if tracer
              __log_failed response if logger
              __raise_transport_error response
            end

            json = __deserialize_response(response)
            if json
              took     = (json['took'] ? sprintf('%.3fs', json['took']/1000.0) : 'n/a') rescue 'n/a' if logger || tracer

              __log   method, path, params, body, url, response, json, took, duration if logger
              __trace method, path, params, body, url, response, json, took, duration if tracer
            end

            # If the response wasn't JSON we just return it as a string
            data = json || response.body
            ::Elasticsearch::Transport::Transport::Response.new response.status, data, response.headers
          end

          def host_unreachable_exceptions
            [::Manticore::Timeout,::Manticore::SocketException, ::Manticore::ClientProtocolException, ::Manticore::ResolutionFailure]
          end
        end
      end
    end
  end
end
