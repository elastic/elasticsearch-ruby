module Elasticsearch
  module API
    module Watcher
      module Actions

        # Force the execution of the watch actions (eg. for testing)
        #
        # @option arguments [String] :id Watch ID (*Required*)
        # @option arguments [Hash] :body Execution control
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-execute-watch.html
        #
        def execute_watch(arguments={})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
          valid_params = [
             ]
          method = 'PUT'
          path   = "_watcher/watch/#{arguments[:id]}/_execute"
          params = {}
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
