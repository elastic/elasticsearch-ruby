module Elasticsearch
  module API
    module Watcher
      module Actions

        # Return information about the installed Watcher plugin
        #
        # @see http://www.elastic.co/guide/en/watcher/current/appendix-api-info.html
        #
        def info(arguments={})
          valid_params = [
             ]
          method = 'GET'
          path   = "/_watcher/"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
