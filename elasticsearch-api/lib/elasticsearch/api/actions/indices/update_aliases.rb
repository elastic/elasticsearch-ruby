module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_UPDATE_ALIASES_PARAMS = [ :timeout ].freeze

        # Perform multiple operation on index aliases in a single request.
        #
        # Pass the `actions` (add, remove) in the `body` argument.
        #
        # @example Add multiple indices to a single alias
        #
        #     client.indices.update_aliases body: {
        #       actions: [
        #         { add: { index: 'logs-2013-06', alias: 'year-2013' } },
        #         { add: { index: 'logs-2013-05', alias: 'year-2013' } }
        #       ]
        #     }
        #
        # @example Swap an alias (atomic operation)
        #
        #     client.indices.update_aliases body: {
        #       actions: [
        #         { remove: { index: 'logs-2013-06', alias: 'current-month' } },
        #         { add:    { index: 'logs-2013-07', alias: 'current-month' } }
        #       ]
        #     }
        #
        # @option arguments [Hash] :body The operations definition and other configuration (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases/
        #
        def update_aliases(arguments={})
          update_aliases_request_for(arguments).body
        end

        def update_aliases_request_for(arguments={})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          method = HTTP_POST
          path   = "_aliases"

          params = Utils.__validate_and_extract_params arguments, VALID_UPDATE_ALIASES_PARAMS
          body   = arguments[:body]

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
