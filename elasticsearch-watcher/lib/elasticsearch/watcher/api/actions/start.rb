module Elasticsearch
  module API
    module Watcher
      module Actions

        # Start the watcher service
        #
        # @see http://www.elastic.co/guide/en/watcher/current/appendix-api-service.html
        #
        def start(arguments={})
          valid_params = [
             ]
          method = 'PUT'
          path   = "/_watcher/_start"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
