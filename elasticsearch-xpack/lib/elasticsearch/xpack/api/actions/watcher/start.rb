module Elasticsearch
  module XPack
    module API
      module Watcher
        module Actions

          # Start the Watcher service
          #
          #
          # @see http://www.elastic.co/guide/en/x-pack/current/watcher-api-start.html
          #
          def start(arguments={})
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/watcher/_start"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
