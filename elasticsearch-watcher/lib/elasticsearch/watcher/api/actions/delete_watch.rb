module Elasticsearch
  module API
    module Watcher
      module Actions

        # Delete a specific watch
        #
        # @option arguments [String] :id Watch ID (*Required*)
        # @option arguments [Boolean] :force Ignore any locks on the watch and force the execution
        #
        # @see http://www.elastic.co/guide/en/watcher/current/appendix-api-delete-watch.html
        #
        def delete_watch(arguments={})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
          valid_params = [
            :master_timeout,
            :force
          ]
          method = 'DELETE'
          path   = "_watcher/watch/#{arguments[:id]}"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
