module Elasticsearch
  module API
    module Cluster
      module Actions

        # Perform manual shard allocation in the cluster.
        #
        # Pass the operations you want to perform in the `:body` option. Use the `dry_run` option to
        # evaluate the result of operations without actually performing them.
        #
        # @example Move shard `0` of index `myindex` from node named _Node1_ to node named _Node2_
        #
        #     client.cluster.reroute body: {
        #       commands: [
        #         { move: { index: 'myindex', shard: 0, from_node: 'Node1', to_node: 'Node2' } }
        #       ]
        #     }
        #
        # @note If you want to explicitly set the shard allocation to a certain node, you might
        #       want to look at the `allocation.*` cluster settings.
        #
        # @option arguments [Hash] :body The definition of `commands` to perform (`move`, `cancel`, `allocate`)
        # @option arguments [Boolean] :dry_run Simulate the operation only and return the resulting state
        # @option arguments [Boolean] :explain Return an explanation of why the commands can or cannot be executed
        # @option arguments [Boolean] :retry_failed Retries allocation of shards that are blocked due to too many
        #   subsequent allocation failures
        # @option arguments [List] :metric Limit the information returned to the specified metrics. Defaults to all
        #   but metadata (options: _all, blocks, metadata, nodes, routing_table, master_node, version)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-reroute/
        #
        def reroute(arguments={})
          method = HTTP_POST
          path   = "_cluster/reroute"

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body] || {}

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:reroute, [
            :dry_run,
            :explain,
            :retry_failed,
            :metric,
            :master_timeout,
            :timeout ].freeze)
      end
    end
  end
end
