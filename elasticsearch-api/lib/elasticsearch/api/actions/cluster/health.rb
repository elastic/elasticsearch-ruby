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
        # @option arguments [String] :index Limit the information returned to a specific index
        # @option arguments [String] :level Specify the level of detail for returned information
        #                                   (options: cluster, indices, shards)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Number] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [Number] :wait_for_nodes Wait until the specified number of nodes is available
        # @option arguments [Number] :wait_for_relocating_shards Wait until the specified number of relocating
        #                                                        shards is finished
        # @option arguments [String] :wait_for_status Wait until cluster is in a specific state
        #                                             (options: green, yellow, red)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-health/
        #
        def health(arguments={})
          valid_params = [
            :level,
            :local,
            :master_timeout,
            :timeout,
            :wait_for_active_shards,
            :wait_for_nodes,
            :wait_for_relocating_shards,
            :wait_for_status ]

          method = HTTP_GET
          path   = "_cluster/health"

          params = Utils.__validate_and_extract_params arguments, valid_params
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
