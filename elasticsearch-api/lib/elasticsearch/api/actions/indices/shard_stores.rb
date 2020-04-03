# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Provides store information for shard copies of indices.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [List] :status A comma-separated list of statuses used to filter on shards to get store information for
        #   (options: green,yellow,red,all)

        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both.
        #   (options: open,closed,hidden,none,all)

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/indices-shards-stores.html
        #
        def shard_stores(arguments = {})
          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "#{Utils.__listify(_index)}/_shard_stores"
                   else
                     "_shard_stores"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:shard_stores, [
          :status,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards
        ].freeze)
end
      end
  end
end
