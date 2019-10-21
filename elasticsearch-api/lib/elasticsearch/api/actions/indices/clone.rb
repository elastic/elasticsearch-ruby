# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions

        # Clone an existing index into a new index, where each original primary shard is cloned into a
        #   new primary shard in the new index.
        #
        # @example Clone index named _myindex_
        #
        #     client.indices.clone(index: 'my_source_index', target: 'my_target_index')
        #
        # @option arguments [String] :index The name of the source index to clone (*Required*)
        # @option arguments [String] :target The name of the target index to clone into (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [String] :wait_for_active_shards Set the number of active shards to wait for on
        #   the cloned index before the operation returns.
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-clone-index.html
        #
        def clone(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]
          method = HTTP_POST
          arguments = arguments.clone

          body = arguments.delete(:body)
          path   = Utils.__pathify(arguments.delete(:index), '_clone', arguments.delete(:target))
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 7.4.0
        ParamsRegistry.register(:clone, [
            :timeout,
            :master_timeout,
            :wait_for_active_shards ].freeze)
      end
    end
  end
end
