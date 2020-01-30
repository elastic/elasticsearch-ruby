# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cluster
      module Actions
        # Returns basic information about the health of the cluster.
        #
        # @option arguments [List] :index Limit the information returned to a specific index
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both.
        #   (options: open,closed,none,all)

        # @option arguments [String] :level Specify the level of detail for returned information
        #   (options: cluster,indices,shards)

        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [String] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [String] :wait_for_nodes Wait until the specified number of nodes is available
        # @option arguments [String] :wait_for_events Wait until all currently queued events with the given priority are processed
        #   (options: immediate,urgent,high,normal,low,languid)

        # @option arguments [Boolean] :wait_for_no_relocating_shards Whether to wait until there are no relocating shards in the cluster
        # @option arguments [Boolean] :wait_for_no_initializing_shards Whether to wait until there are no initializing shards in the cluster
        # @option arguments [String] :wait_for_status Wait until cluster is in a specific state
        #   (options: green,yellow,red)

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/cluster-health.html
        #
        def health(arguments = {})
          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = HTTP_GET
          path   = if _index
                     "_cluster/health/#{Utils.__listify(_index)}"
                   else
                     "_cluster/health"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:health, [
          :expand_wildcards,
          :level,
          :local,
          :master_timeout,
          :timeout,
          :wait_for_active_shards,
          :wait_for_nodes,
          :wait_for_events,
          :wait_for_no_relocating_shards,
          :wait_for_no_initializing_shards,
          :wait_for_status
        ].freeze)
end
      end
  end
end
