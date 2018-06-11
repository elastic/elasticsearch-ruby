module Elasticsearch
  module API
    module Indices
      module Actions

        # The split index API allows you to split an existing index into a new index,
        # where each original primary shard is split into two or more primary shards in the new index.
        #
        # @option arguments [String] :index The name of the source index to split (*Required*)
        # @option arguments [String] :target The name of the target index to split into (*Required*)
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on the shrunken index before the operation returns.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-split-index.html
        #
        def split(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]
          valid_params = [
            :timeout,
            :master_timeout,
            :wait_for_active_shards ]
          method = HTTP_PUT
          path   = Utils.__pathify Utils.__escape(arguments[:index]), '_split', Utils.__escape(arguments[:target])
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
