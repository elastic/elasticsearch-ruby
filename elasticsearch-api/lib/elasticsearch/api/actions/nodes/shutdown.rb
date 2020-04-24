# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Nodes
      module Actions

        # Shutdown one or all nodes
        #
        # @example Shut down node named _Bloke_
        #
        #     client.nodes.shutdown node_id: 'Bloke'
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to perform the operation on; use
        #                                   `_local` to shutdown the node you're connected to, leave empty to
        #                                   shutdown all nodes
        # @option arguments [Time] :delay Set the delay for the operation (default: 1s)
        # @option arguments [Boolean] :exit Exit the JVM as well (default: true)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-nodes-shutdown/
        #
        def shutdown(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify '_cluster/nodes', Utils.__listify(arguments[:node_id]), '_shutdown'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:shutdown, [
            :delay,
            :exit ].freeze)
      end
    end
  end
end
