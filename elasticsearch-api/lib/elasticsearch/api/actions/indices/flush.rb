module Elasticsearch
  module API
    module Indices
      module Actions

        # "Flush" the index or indices.
        #
        # The "flush" operation clears the transaction log and memory and writes data to disk.
        # It corresponds to a Lucene "commit" operation.
        #
        # @note The flush operation is handled automatically by Elasticsearch, you don't need to perform it manually.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string for all indices
        # @option arguments [Boolean] :force Whether a flush should be forced even if it is not necessarily needed ie. if no changes will be committed to the index. This is useful if transaction log IDs should be incremented even if no uncommitted changes are present. (This setting can be considered as internal)
        # @option arguments [Boolean] :wait_if_ongoing If set to true the flush operation will block until the flush can be executed if another flush operation is already executing. The default is true. If set to false the flush will be skipped iff if another flush operation is already running.
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-flush/
        #
        def flush(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_flush'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:flush, [
            :force,
            :wait_if_ongoing,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards ].freeze)
      end
    end
  end
end
