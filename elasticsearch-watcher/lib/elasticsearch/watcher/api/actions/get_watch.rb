module Elasticsearch
  module API
    module Watcher
      module Actions

        # Get a specific watch
        #
        # @option arguments [String] :id Watch ID (*Required*)
        #
        # @see http://www.elastic.co/guide/en/watcher/current/appendix-api-get-watch.html
        #
        def get_watch(arguments={})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
          valid_params = [
             ]
          method = 'GET'
          path   = "_watcher/watch/#{arguments[:id]}"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        rescue Exception => e
          # NOTE: Use exception name, not full class in Elasticsearch::Client to allow client plugability
          if Array(arguments[:ignore]).include?(404) && e.class.to_s =~ /NotFound/; false
          else raise(e)
          end
        end
      end
    end
  end
end
