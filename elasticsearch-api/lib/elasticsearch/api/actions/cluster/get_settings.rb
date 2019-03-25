module Elasticsearch
  module API
    module Cluster
      module Actions

        # Get the cluster settings (previously set with {Cluster::Actions#put_settings})
        #
        # @example Get cluster settings
        #
        #     client.cluster.get_settings
        #
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :include_defaults Whether to return all default clusters setting.
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-update-settings/
        #
        def get_settings(arguments={})
          method = HTTP_GET
          path   = "_cluster/settings"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get_settings, [
            :flat_settings,
            :master_timeout,
            :timeout,
            :include_defaults ].freeze)
      end
    end
  end
end
