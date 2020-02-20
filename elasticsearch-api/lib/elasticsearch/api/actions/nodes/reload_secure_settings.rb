# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Nodes
      module Actions
        # Reloads secure settings.
        #
        # @option arguments [List] :node_id A comma-separated list of node IDs to span the reload/reinit call. Should stay empty because reloading usually involves all cluster nodes.
        # @option arguments [Time] :timeout Explicit operation timeout

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/secure-settings.html#reloadable-secure-settings
        #
        def reload_secure_settings(arguments = {})
          arguments = arguments.clone

          _node_id = arguments.delete(:node_id)

          method = Elasticsearch::API::HTTP_POST
          path   = if _node_id
                     "_nodes/#{Utils.__listify(_node_id)}/reload_secure_settings"
                   else
                     "_nodes/reload_secure_settings"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:reload_secure_settings, [
          :timeout
        ].freeze)
end
      end
  end
end
