module Elasticsearch
  module Transport
    module Transport
      module HTTP

        # Alternative HTTP transport implementation, using the [_Curb_](https://rubygems.org/gems/curb) client.
        #
        # @see Transport::Base
        #
        class Curb
          include Base

          # Performs the request by invoking {Transport::Base#perform_request} with a block.
          #
          # @return [Response]
          # @see    Transport::Base#perform_request
          #
          def perform_request(method, path, params={}, body=nil)
            super do |connection,url|
              connection.connection.url = url

              case method
                when 'HEAD'
                when 'GET', 'POST', 'PUT', 'DELETE'
                  connection.connection.put_data = __convert_to_json(body) if body
                else raise ArgumentError, "Unsupported HTTP method: #{method}"
              end

              connection.connection.http(method.to_sym)

              headers = {}
              headers['content-type'] = 'application/json' if connection.connection.header_str =~ /\/json/

              Response.new connection.connection.response_code,
                           connection.connection.body_str,
                           headers
            end
          end

          # Builds and returns a collection of connections.
          #
          # @return [Connections::Collection]
          #
          def __build_connections
            Connections::Collection.new \
              :connections => hosts.map { |host|
                host[:protocol]   = host[:scheme] || DEFAULT_PROTOCOL
                host[:port]     ||= DEFAULT_PORT

                client = ::Curl::Easy.new
                client.resolve_mode = :ipv4
                client.headers      = {'User-Agent' => "Curb #{Curl::CURB_VERSION}"}
                client.url          = __full_url(host)

                if host[:user]
                  client.http_auth_types = host[:auth_type] || :basic
                  client.username = host[:user]
                  client.password = host[:password]
                end

                client.instance_eval &@block if @block

                Connections::Connection.new :host => host, :connection => client
              },
              :selector => options[:selector]
          end

          # Returns an array of implementation specific connection errors.
          #
          # @return [Array]
          #
          def host_unreachable_exceptions
            [::Curl::Err::HostResolutionError, ::Curl::Err::ConnectionFailedError]
          end
        end

      end
    end
  end
end
