module Elasticsearch
  module API
    module Indices
      module Actions

        # Return the settings for all indices, or a list of indices.
        #
        # @example Get settings for all indices
        #
        #     client.indices.get_settings
        #
        # @example Get settings for the 'foo' index
        #
        #     client.indices.get_settings index: 'foo'
        #
        # @example Get settings for indices beginning with foo
        #
        #     client.indices.get_settings prefix: 'foo'
        #
        # @example Get settings for an index named _myindex_
        #
        #     client.indices.get_settings index: 'myindex'
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string to perform the operation on all indices
        # @option arguments [List] :name The name of the settings that should be included
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Boolean] :include_defaults Whether to return all default setting for each of the indices.
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-settings.html
        #
        def get_settings(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify Utils.__listify(arguments[:index]),
                                   Utils.__listify(arguments[:type]),
                                   arguments.delete(:prefix),
                                   '_settings',
                                   Utils.__escape(arguments[:name])
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get_settings, [
            :master_timeout,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :flat_settings,
            :local,
            :include_defaults ].freeze)
      end
    end
  end
end
