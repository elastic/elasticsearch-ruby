module Elasticsearch
  module API
    module Indices
      module Actions

        # Return true if the specified alias exists, false otherwise.
        #
        # @example Check whether index alias named _myalias_ exists
        #
        #     client.indices.exists_alias? name: 'myalias'
        #
        # @option arguments [List] :index A comma-separated list of index names to filter aliases
        # @option arguments [List] :name A comma-separated list of alias names to return (*Required*)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html
        #
        def exists_alias(arguments={})
          method = HTTP_HEAD
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_alias', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          Utils.__rescue_from_not_found do
            perform_request(method, path, params, body).status == 200 ? true : false
          end
        end
        alias_method :exists_alias?, :exists_alias

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:exists_alias, [
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :local ].freeze)
      end
    end
  end
end
