module Elasticsearch
  module API
    module Indices
      module Actions

        # Upgrade the index or indices to the latest Lucene format.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :wait_for_completion Specify whether the request should block until the all segments are upgraded (default: false)
        # @option arguments [Boolean] :only_ancient_segments If true, only ancient (an older Lucene major release) segments will be upgraded
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-upgrade.html
        #
        def upgrade(arguments={})
          method = HTTP_POST
          path   = "_upgrade"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:upgrade, [
            :allow_no_indices,
            :expand_wildcards,
            :ignore_unavailable,
            :wait_for_completion,
            :only_ancient_segments ].freeze)
      end
    end
  end
end
