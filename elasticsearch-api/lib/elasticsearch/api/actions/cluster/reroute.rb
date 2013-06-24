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
        # @note If you want to explicitely set the shard allocation to a certain node, you might
        #       want to look at the `allocation.*` cluster settings.
        #
        # @option arguments [Hash] :body The definition of `commands` to perform (`move`, `cancel`, `allocate`)
        # @option arguments [Boolean] :dry_run Simulate the operation only and return the resulting state
        # @option arguments [Boolean] :filter_metadata Don't return cluster state metadata (default: false)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-reroute/
        #
        def reroute(arguments={})
          method = 'POST'
          path   = "_cluster/reroute"
          params = arguments.select do |k,v|
            [ :dry_run,
              :filter_metadata ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body   = arguments[:body] || {}

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
