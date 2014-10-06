require 'manticore'

module Elasticsearch
  module Transport
    module Transport
      module HTTP
        # Alternative HTTP transport implementation for JRuby,
        # using the [_Manticore_](https://github.com/cheald/manticore) client,
        #
        # @example
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
        # @see Transport::Base
        #
        class Manticore
          include Base

          # Performs the request by invoking {Transport::Base#perform_request} with a block.
          #
          # @return [Response]
          # @see    Transport::Base#perform_request
          #
          def perform_request(method, path, params={}, body=nil)
            super do |connection, url|
              params[:body] = __convert_to_json(body) if body
              params = params.merge @request_options
              case method
              when "GET"
                resp = connection.connection.get(url, params)
              when "HEAD"
                resp = connection.connection.head(url, params)
              when "PUT"
                resp = connection.connection.put(url, params)
              when "POST"
                resp = connection.connection.post(url, params)
              when "DELETE"
                resp = connection.connection.delete(url, params)
              else
                raise ArgumentError.new "Method #{method} not supported"
              end
              Response.new resp.code, resp.read_body, resp.headers
            end
          end

          # Builds and returns a collection of connections.
          # Each connection is a Manticore::Client
          #
          # @return [Connections::Collection]
          #
          def __build_connections
            @request_options = {}

            if options.key?(:headers)
              @request_options[:headers] = options[:headers]
            end

            client_options = setup_ssl(options[:ssl] || {})

            Connections::Collection.new \
              :connections => hosts.map { |host|
                host[:protocol]   = host[:scheme] || DEFAULT_PROTOCOL
                host[:port]     ||= DEFAULT_PORT

                host.delete(:user)     # auth is not supported here.
                host.delete(:password) # use the headers

                url               = __full_url(host)

                Connections::Connection.new \
                  :host => host,
                  :connection => ::Manticore::Client.new(:options => client_options)
              },
              :selector_class => options[:selector_class],
              :selector => options[:selector]
          end

          # Returns an array of implementation specific connection errors.
          #
          # @return [Array]
          #
          def host_unreachable_exceptions
            [
              ::Manticore::Timeout,
              ::Manticore::SocketException,
              ::Manticore::ClientProtocolException,
              ::Manticore::ResolutionFailure
            ]
          end

          private
          # TODO: not threadsafe
          def setup_ssl(ssl_options)
            if ssl_options[:truststore]
              java.lang.System.setProperty "javax.net.ssl.trustStore", ssl_options[:truststore]
            end
            if ssl_options[:truststore_password]
              java.lang.System.setProperty "javax.net.ssl.trustStorePassword", ssl_options[:truststore_password]
            end
            if ssl_options[:verify] == false then
              { :ignore_ssl_validation => true }
            else
              {}
            end
          end
        end
      end
    end
  end
end
