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
            @adapter = Adapter.new(arguments[:options], logger)
            # TODO handle HTTPS
            @pool = Manticore::Pool.new(@adapter, arguments[:hosts].map {|h| URI::HTTP.build(h).to_s})
            @options = arguments[:options] || {}
            @serializer = options[:serializer] || ( options[:serializer_class] ? options[:serializer_class].new(self) : DEFAULT_SERIALIZER_CLASS.new(self) )
            if options[:sniffer_class]
              # We don't support sniffers that aren't threadsafe with timers here!
              raise ArgumentError, "Sniffer must be a ManticoreSniffer!" unless @sniffer.is_a?(ManticoreSniffer)
              @sniffer = options[:sniffer_class] ? options[:sniffer_class].new(self, logger) : ManticoreSniffer.new(self, logger)
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
