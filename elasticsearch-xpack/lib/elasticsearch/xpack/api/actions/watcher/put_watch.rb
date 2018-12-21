module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions

          # Register a new watch in or update an existing one
          #
          # @option arguments [String] :id Watch ID (*Required*)
          # @option arguments [Hash] :body The watch (*Required*)
          # @option arguments [Duration] :master_timeout Specify timeout for watch write operation
          # @option arguments [Boolean] :active Specify whether the watch is in/active by default
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/watcher-api-put-watch.html
          #
          def put_watch(arguments={})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            valid_params = [
              :master_timeout,
              :active,
              :version ]

            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/watcher/watch/#{arguments[:id]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
