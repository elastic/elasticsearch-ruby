module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions

          # Force the execution of a stored watch
          #
          # @option arguments [String] :id Watch ID
          # @option arguments [Hash] :body Execution control
          # @option arguments [Boolean] :debug indicates whether the watch should execute in debug mode
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/watcher-api-execute-watch.html
          #
          def execute_watch(arguments={})
            valid_params = [ :debug ]
            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/watcher/watch/#{arguments[:id]}/_execute"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
