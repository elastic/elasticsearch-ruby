# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions

        # The split index API allows you to split an existing index into a new index with multiple of its primary shards.
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
          arguments = arguments.clone
          source = arguments.delete(:index)
          target = arguments.delete(:target)

          method = Elasticsearch::API::HTTP_PUT
          path   = Utils.__pathify Utils.__escape(source), '_split', Utils.__escape(target)
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:split, [
            :timeout,
            :master_timeout,
            :wait_for_active_shards ].freeze)
      end
    end
  end
end
