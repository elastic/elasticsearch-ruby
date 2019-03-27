module Elasticsearch
  module API
    module Indices
      module Actions

        # Open a previously closed index (see the {Indices::Actions#close} API).
        #
        # @example Open index named _myindex_
        #
        #     client.indices.open index: 'myindex'
        #
        # @option arguments [List] :index A comma separated list of indices to open (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [String] :wait_for_active_shards Sets the number of active shards to wait for before the operation returns.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html
        #
        def open(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = HTTP_POST
          path   = Utils.__pathify Utils.__escape(arguments[:index]), '_open'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:open, [
            :timeout,
            :master_timeout,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :wait_for_active_shards ].freeze)
      end
    end
  end
end
