module Elasticsearch
  module API
    module Watcher
      module Actions

        # Create a new watch or update an existing one
        #
        # @option arguments [String] :id Watch ID (*Required*)
        # @option arguments [Hash] :body The watch (*Required*)
        # @option arguments [Boolean] :pretty Pretty the output
        #
        # @see http://www.elastic.co/guide/en/watcher/current/appendix-api-put-watch.html
        #
        def put_watch(arguments={})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          valid_params = [
            :master_timeout ]
          method = 'PUT'
          path   = "_watcher/watch/#{arguments[:id]}"
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
