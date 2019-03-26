module Elasticsearch
  module API
    module Indices
      module Actions

        # Update the settings for one or multiple indices.
        #
        # @example Change the number of replicas for all indices
        #
        #     client.indices.put_settings body: { index: { number_of_replicas: 0 } }
        #
        #
        # @example Change the number of replicas for a specific index
        #
        #     client.indices.put_settings index: 'myindex', body: { index: { number_of_replicas: 0 } }
        #
        #
        # @example Disable "flush" for all indices
        #
        #     client.indices.put_settings body: { 'index.translog.disable_flush' => true }
        #
        # @example Allocate specific index on specific nodes
        #
        #     client.indices.put_settings index: 'my-big-index',
        #                                 body: { 'index.routing.allocation.require.tag' => 'bigbox' }
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
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-get-settings.html
        #
        def put_settings(arguments={})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = HTTP_PUT
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_settings'
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

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
