require 'manticore'

module Elasticsearch
  module Transport
    module Transport
      module HTTP
        class Manticore
          include Base
          def perform_request(method, path, params={}, body=nil)
            super do |connection, url|
              params[:body] = __convert_to_json(body) if body
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
          def __build_connections
            # TODO: not threadsafe
            ssl_options = options[:transport_options][:ssl] || {}
            if ssl_options[:truststore]
              java.lang.System.setProperty "javax.net.ssl.trustStore", ssl_options[:truststore]
            end
            if ssl_options[:truststore_password]
              java.lang.System.setProperty "javax.net.ssl.trustStorePassword", ssl_options[:truststore_password]
            end
            if ssl_options[:verify] == false
              options[:transport_options][:ignore_ssl_validation] = true
            end
            Connections::Collection.new \
              :connections => hosts.map { |host|
                host[:protocol]   = host[:scheme] || DEFAULT_PROTOCOL
                host[:port]     ||= DEFAULT_PORT
                url               = __full_url(host)

                Connections::Connection.new \
                  :host => host,
                  :connection => ::Manticore::Client.new(options[:transport_options] || {})
              },
              :selector_class => options[:selector_class],
              :selector => options[:selector]
          end

          def host_unreachable_exceptions
            [
              Manticore::Timeout,
              Manticore::SocketException,
              Manticore::ClientProtocolException,
              Manticore::ResolutionFailure
            ]
          end
        end
      end
    end
  end
end
