module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_PUT_SETTINGS_PARAMS = [
          :ignore_indices,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :master_timeout,
          :flat_settings
        ].freeze

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
        # @option arguments [Hash] :body The index settings to be updated (*Required*)
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
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-update-settings/
        #
        def put_settings(arguments={})
          put_settings_request_for(arguments).body
        end

        def put_settings_request_for(arguments={})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          method = HTTP_PUT
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_settings'
          params = Utils.__validate_and_extract_params arguments, VALID_PUT_SETTINGS_PARAMS
          body   = arguments[:body]

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
