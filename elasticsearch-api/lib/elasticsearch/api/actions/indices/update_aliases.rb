# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions

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
        # @option arguments [Hash] :body The definition of `actions` to perform (*Required*)
        # @option arguments [Time] :timeout Request timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see https://www.elastic.co/guide/reference/api/admin-indices-aliases/
        #
        def update_aliases(arguments={})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = HTTP_POST
          path   = "_aliases"

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:update_aliases, [
            :timeout,
            :master_timeout ].freeze)
      end
    end
  end
end
