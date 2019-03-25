module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns information about cluster "health".
        #
        # @example Get the cluster health information
        #
        #     client.cluster.health
        #
        # @example Block the request until the cluster is in the "yellow" state
        #
        #     client.cluster.health wait_for_status: 'yellow'
        #
        # @option arguments [List] :index Limit the information returned to a specific index
        # @option arguments [String] :level Specify the level of detail for returned information (options: cluster, indices, shards)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [String] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [String] :wait_for_nodes Wait until the specified number of nodes is available
        # @option arguments [String] :wait_for_events Wait until all currently queued events with the given priority are processed (options: immediate, urgent, high, normal, low, languid)
        # @option arguments [Boolean] :wait_for_no_relocating_shards Whether to wait until there are no relocating shards in the cluster
        # @option arguments [Boolean] :wait_for_no_initializing_shards Whether to wait until there are no initializing shards in the cluster
        # @option arguments [String] :wait_for_status Wait until cluster is in a specific state (options: green, yellow, red)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-health/
        #
        def health(arguments={})
          arguments = arguments.clone
          index     = arguments.delete(:index)
          method = HTTP_GET
          path   = Utils.__pathify "_cluster/health", Utils.__listify(index)

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:health, [
            :level,
            :local,
            :master_timeout,
            :timeout,
            :wait_for_active_shards,
            :wait_for_nodes,
            :wait_for_events,
            :wait_for_no_relocating_shards,
            :wait_for_no_initializing_shards,
            :wait_for_status ].freeze)
      end
    end
  end
end
