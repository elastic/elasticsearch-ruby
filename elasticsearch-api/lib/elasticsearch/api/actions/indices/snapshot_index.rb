module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_SNAPSHOT_INDEX_PARAMS = [
          :ignore_indices,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards
        ].freeze

        # When using the shared storage gateway, manually trigger the snapshot operation.
        #
        # @deprecated The shared gateway has been deprecated [https://github.com/elasticsearch/elasticsearch/issues/2458]
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                to perform the operation on all indices
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
        #                                               no concrete indices. (This includes `_all` string or when no
        #                                               indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #                                              are open, closed or both. (options: open, closed)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
        #                                            `missing` ones (options: none, missing) @until 1.0
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-gateway-snapshot/
        #
        def snapshot_index(arguments={})
          snapshot_index_request_for(arguments).body
        end

        def snapshot_index_request_for(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_gateway/snapshot'

          params = Utils.__validate_and_extract_params arguments, VALID_SNAPSHOT_INDEX_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
