module Elasticsearch
  module API
    module Nodes
      module Actions

        # The cluster nodes usage API allows to retrieve information on the usage of features for each node.
        #
        # @option arguments [List] :metric Limit the information returned to the specified metrics (options: _all,rest_actions)      
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes      
        # @option arguments [Time] :timeout Explicit operation timeout      
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-usage.html
        #
        def usage(arguments={})
          method = Elasticsearch::API::HTTP_GET
          path   = "_nodes/usage"
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:usage, [
            :timeout ].freeze)
      end
    end
  end
end
