module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns statistical information about the cluster
        #
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned
        #   information; use `_local` to return information from the node you're connecting to, leave empty to get
        #   information from all nodes
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-stats.html
        #
        def stats(arguments={})
          method = 'GET'
          node_id = arguments.delete(:node_id)

          if node_id
            path = Utils.__pathify("_cluster/stats/nodes", node_id)
          else
            path = "_cluster/stats"
          end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:stats, [
            :flat_settings,
            :timeout ].freeze)
      end
    end
  end
end
