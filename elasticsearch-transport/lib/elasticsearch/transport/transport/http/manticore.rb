require 'manticore'
require "elasticsearch/transport/transport/http/manticore/pool"
require "elasticsearch/transport/transport/http/manticore/adapter"

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
            @options = arguments[:options]
            @logger = options[:logger]
            @adapter = Adapter.new(logger, options)
            # TODO handle HTTPS
            @pool = Manticore::Pool.new(logger, @adapter, arguments[:hosts].map {|h| URI::HTTP.build(h).to_s})
            @protocol    = options[:protocol] || DEFAULT_PROTOCOL
            @serializer = options[:serializer] || ( options[:serializer_class] ? options[:serializer_class].new(self) : DEFAULT_SERIALIZER_CLASS.new(self) )
            @retry_on_status = Array(options[:retry_on_status]).map { |d| d.to_i }

            if options[:sniffing]
              # We don't support sniffers that aren't threadsafe with timers here!
              sniffer_class = options[:sniffer_class] ? options[:sniffer_class] : ManticoreSniffer
              raise ArgumentError, "Sniffer class #{sniffer_class} must be a ManticoreSniffer!" if sniffer_class.nil? || !sniffer_class.ancestors.include?(ManticoreSniffer)
              @sniffer = sniffer_class.new(self, logger)
              @sniffer.sniff_every(options[:sniffer_delay] || 5) do |urls|
                logger.info("Will update internal host pool with #{urls.inspect}")
                @pool.update_urls(urls)
              end
            end
          end

          def perform_request(method, path, params={}, body=nil)
            with_request_retries do
              body = __convert_to_json(body) if body
              enriching_response(method, path, params, body) do
                url, response = @pool.perform_request(method, path, params, body)

                # Raise an exception so we can catch it for `retry_on_status`
                __raise_transport_error(response) if response.status.to_i >= 300 && @retry_on_status.include?(response.status.to_i)
                [url, response]
              end
            end
          end

          def __close_connections
            @adapter.manticore.close
          end
        end
      end
    end
  end
end
