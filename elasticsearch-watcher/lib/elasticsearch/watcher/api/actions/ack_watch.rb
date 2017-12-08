module Elasticsearch
  module API
    module Watcher
      module Actions

        # Throttle the execution of the watch by acknowledging it
        #
        # @option arguments [String] :id Watch ID (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-ack-watch.html
        #
        def ack_watch(arguments={})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
          valid_params = [
            :master_timeout
          ]
          method = 'PUT'
          path   = "_watcher/watch/#{arguments[:id]}/_ack"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
