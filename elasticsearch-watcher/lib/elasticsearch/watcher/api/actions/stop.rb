module Elasticsearch
  module API
    module Watcher
      module Actions

        # Stop the watcher service
        #
        # @see http://www.elastic.co/guide/en/watcher/current/appendix-api-service.html
        #
        def stop(arguments={})
          valid_params = [
             ]
          method = 'PUT'
          path   = "/_watcher/_stop"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
