module Elasticsearch
  module API
    module Indices
      module Actions

        # Create or update mapping.
        #
        # Pass the mapping definition(s) in the `:body` argument.
        #
        # @example Create or update a mapping for a specific document type
        #
        #     client.indices.put_mapping index: 'myindex', type: 'mytype', body: {
        #       mytype: {
        #         properties: {
        #           title: { type: 'string', analyzer: 'snowball' }
        #         }
        #       }
        #     }
        #
        # @example Update the mapping for a specific type in all indices
        #
        #     client.indices.put_mapping type: 'mytype', body: {
        #       mytype: {
        #         dynamic: 'strict'
        #       }
        #     }
        #
        # @option arguments [List] :index A comma-separated list of index names the mapping should be added to (supports wildcards); use `_all` or omit to add the mapping on all indices.
        # @option arguments [String] :type The name of the document type (*Required*)
        # @option arguments [Hash] :body The mapping definition (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        # @option arguments [Boolean] :update_all_types Whether to update the mapping for all fields with the same name across all types or not
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html
        #
        def put_mapping(arguments={})
          raise ArgumentError, "Required argument 'body' missing"  unless arguments[:body]
          method = HTTP_PUT
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_mapping', Utils.__escape(arguments[:type])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:put_mapping, [
            :timeout,
            :master_timeout,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :update_all_types,
            :include_type_name ].freeze)
      end
    end
  end
end
