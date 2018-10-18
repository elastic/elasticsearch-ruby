module Elasticsearch
  module API
    module Nodes
      module Actions

        # Re-read the local node's encrypted keystore. Specifically, it will prompt the keystore
        # decryption and reading across the cluster.
        #
        # @example Reload secure settings for all nodes
        #
        #     client.nodes.reload_secure_settings
        #
        # @example Reload secure settings for a list of nodes
        #
        #     client.nodes.reload_secure_settings(node_id: 'foo,bar')
        #
        # @option arguments [ Array ] :node_id A comma-separated list of node IDs or names to perform the operation on
        # @option arguments [ String ] :timeout Explicit operation timeout
        #
        # @see http://elasticsearch.org/guide/reference/api/cluster-nodes-reload-secure-settings
        #
        def reload_secure_settings(arguments={})
          valid_params = [
              :timeout ]

          method = HTTP_POST
          path   = Utils.__pathify '_nodes', Utils.__listify(arguments[:node_id]), 'reload_secure_settings'

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
