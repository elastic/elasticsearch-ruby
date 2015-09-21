module Elasticsearch
  module API
    module Nodes
      module Actions

        VALID_SHUTDOWN_PARAMS = [
          :delay,
          :exit
        ].freeze

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
          shutdown_request_for(arguments).body
        end

        def shutdown_request_for(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify '_cluster/nodes', Utils.__listify(arguments[:node_id]), '_shutdown'

          params = Utils.__validate_and_extract_params arguments, VALID_SHUTDOWN_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
