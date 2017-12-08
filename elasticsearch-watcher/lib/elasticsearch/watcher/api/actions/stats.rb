module Elasticsearch
  module API
    module Watcher
      module Actions

        # Return statistical information about the watcher service
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-stats.html
        #
        def stats(arguments={})
          valid_params = [
             ]
          method = 'GET'
          path   = "/_watcher/stats"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
