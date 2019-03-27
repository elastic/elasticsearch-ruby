module Elasticsearch
  module API
    module Indices
      module Actions

        # Return true if the index (or all indices in a list) exists, false otherwise.
        #
        # @example Check whether index named _myindex_ exists
        #
        #     client.indices.exists? index: 'myindex'
        #
        # @option arguments [List] :index A comma-separated list of index names (*Required*)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Boolean] :ignore_unavailable Ignore unavailable indexes (default: false)
        # @option arguments [Boolean] :allow_no_indices Ignore if a wildcard expression resolves to no concrete indices (default: false)
        # @option arguments [String] :expand_wildcards Whether wildcard expressions should get expanded to open or closed indices (default: open) (options: open, closed, none, all)
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Boolean] :include_defaults Whether to return all default setting for each of the indices.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html
        #
        def exists(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = HTTP_HEAD
          path   = Utils.__listify(arguments[:index])
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          Utils.__rescue_from_not_found do
            perform_request(method, path, params, body).status == 200 ? true : false
          end
        end
        alias_method :exists?, :exists

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:exists, [
            :local,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :flat_settings,
            :include_defaults ].freeze)
      end
    end
  end
end
