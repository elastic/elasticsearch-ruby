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
        # @option arguments [List] :node_id A comma-separated list of node IDs to span the reload/reinit call. Should stay empty because reloading usually involves all cluster nodes.
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/6.x/secure-settings.html#reloadable-secure-settings
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

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:reload_secure_settings, [
            :timeout ].freeze)
      end
    end
  end
end
