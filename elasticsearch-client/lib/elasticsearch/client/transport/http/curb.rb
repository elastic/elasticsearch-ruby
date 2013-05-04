module Elasticsearch
  module Client
    module Transport
      module HTTP

        class Curb
          include Base

          def perform_request(method, path, params={}, body=nil)
            super do |connection,url|
              connection.connection.url = url

              case method
                when 'HEAD', 'GET' then connection.connection.http method.downcase.to_sym
                when 'PUT'         then connection.connection.http_put serializer.dump(body)
                when 'DELETE'      then connection.connection.http_delete
                when 'POST'
                  connection.connection.post_body = serializer.dump(body)
                  connection.connection.http_post
                else raise ArgumentError, "Unsupported HTTP method: #{method}"
              end

              Response.new connection.connection.response_code, connection.connection.body_str
            end
          end

          def __build_connections
            Connections::Collection.new \
              :connections => hosts.map { |host|
                host[:protocol] ||= DEFAULT_PROTOCOL
                host[:port]     ||= DEFAULT_PORT

                client = ::Curl::Easy.new
                client.resolve_mode = :ipv4
                client.headers      = {'Content-Type' => 'application/json'}
                client.url          = "#{host[:protocol]}://#{host[:host]}:#{host[:port]}"

                client.instance_eval &@block if @block

                Connections::Connection.new :host => host, :connection => client
              },
              :selector => options[:selector]
          end
        end

      end
    end
  end
end
