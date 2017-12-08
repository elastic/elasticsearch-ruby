module Elasticsearch
  module API
    module Watcher
      module Actions

        # Return statistical information about the watcher service
        #
        # @see http://www.elastic.co/guide/en/watcher/current/appendix-api-stats.html
        #
        def stats(arguments={})
          valid_params = [
             ]
          method = 'GET'
          path   = "/_xpack/watcher/stats"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
