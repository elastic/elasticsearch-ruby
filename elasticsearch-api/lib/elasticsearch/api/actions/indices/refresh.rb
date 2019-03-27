module Elasticsearch
  module API
    module Indices
      module Actions

        # Refresh the index and to make the changes (creates, updates, deletes) searchable.
        #
        # By default, Elasticsearch has a delay of 1 second until changes to an index are
        # available for search; the delay is configurable, see {Indices::Actions#put_settings}.
        #
        # You can trigger this operation explicitly, for example when performing a sequence of commands
        # in integration tests, or when you need to perform a manual "synchronization" of the index
        # with an external system at given moment.
        #
        # @example Refresh an index named _myindex_
        #
        #     client.indices.refresh index: 'myindex'
        #
        # @note The refresh operation can adversely affect indexing throughput when used too frequently.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-refresh.html
        #
        def refresh(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_refresh'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:refresh, [
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards ].freeze)
      end
    end
  end
end
