module Elasticsearch
  module API
    module Cluster
      module Actions

        # Get information about the cluster state (indices settings, allocations, etc)
        #
        # @example
        #
        #     client.cluster.state
        #
        # @option arguments [Boolean] :filter_blocks Do not return information about blocks
        # @option arguments [Boolean] :filter_index_templates Do not return information about index templates
        # @option arguments [List] :filter_indices Limit returned metadata information to specific indices
        # @option arguments [Boolean] :filter_metadata Do not return information about indices metadata
        # @option arguments [Boolean] :filter_nodes Do not return information about nodes
        # @option arguments [Boolean] :filter_routing_table Do not return information about shard allocation
        #                                                   (`routing_table` and `routing_nodes`)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-state/
        #
        def state(arguments={})
          method = 'GET'
          path   = "_cluster/state"
          params = arguments.select do |k,v|
            [ :filter_blocks,
              :filter_index_templates,
              :filter_indices,
              :filter_metadata,
              :filter_nodes,
              :filter_routing_table,
              :local,
              :master_timeout ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
