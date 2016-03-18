module Elasticsearch
  module Transport
    module Transport
      module HTTP
        class Manticore
          # While the Manticore Pool only supports Manticore today, one day other adapters
          # may use it. This class provides an abstraction around the actual HTTP client for
          # the pool.
          class Adapter
            attr_reader :manticore, :logger

            def initialize(logger, options)
              @logger = logger
              build_client(options || {})
              sniffer_options = [logger, options[:sniffer_timeout], options[:randomize_hosts]]
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
              url_and_path = (url + path).to_s # Convert URI object to string
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
          end
        end
      end
    end
  end
end