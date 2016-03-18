require 'manticore'
require "elasticsearch/transport/transport/http/manticore/pool"

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
          attr_reader :pool, :adapter
          include Base

          class Adapter
            attr_reader :manticore

            def initialize(options)
              build_client(options || {})
            end

            # Should just be run once at startup
            def build_client(options={})
              client_options = options[:transport_options] || {}
              client_options[:ssl] = options[:ssl] || {}

              @request_options = options[:headers] ? {:headers => options[:headers]} : {}
              @manticore = ::Manticore::Client.new(client_options)
            end

            # Performs the request by invoking {Transport::Base#perform_request} with a block.
            #
            # @return [Response]
            # @see    Transport::Base#perform_request
            #
            def perform_request(url, method, path, params={}, body=nil)
              params = params.merge @request_options
              params[:body] = body if body
              url_and_path = url + path
              case method
                when "GET"
                  resp = @manticore.get(url_and_path, params)
                when "HEAD"
                  resp = @manticore.head(url_and_path, params)
                when "PUT"
                  resp = @manticore.put(url_and_path, params)
                when "POST"
                  resp = @manticore.post(url_and_path, params)
                when "DELETE"
                  resp = @manticore.delete(url_and_path, params)
                else
                  raise ArgumentError.new "Method #{method} not supported"
              end
              Response.new resp.code, resp.read_body, resp.headers
            end

            def close
              @manticore.close
            end

            def add_url(url)
            end

            def remove_url(url)
            end
          end

          def initialize(arguments={}, &block)
            @adapter = Adapter.new(arguments[:options])
            # TODO handle HTTPS
            @pool = Manticore::Pool.new(@adapter, arguments[:hosts].map {|h| URI::HTTP.build(h).to_s})
            options = arguments[:options] || {}
            @serializer  = options[:serializer] || ( options[:serializer_class] ? options[:serializer_class].new(self) : DEFAULT_SERIALIZER_CLASS.new(self) )
          end

          def perform_request(method, path, params={}, body=nil)
            body = __convert_to_json(body) if body
            @pool.perform_request(method, path, params, body)
          end
        end
      end
    end
  end
end
