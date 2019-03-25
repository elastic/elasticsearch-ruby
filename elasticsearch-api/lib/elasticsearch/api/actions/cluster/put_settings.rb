module Elasticsearch
  module API
    module Cluster
      module Actions

        # Update cluster settings.
        #
        # @example Disable shard allocation in the cluster until restart
        #
        #     client.cluster.put_settings body: { transient: { 'cluster.routing.allocation.disable_allocation' => true } }
        #
        # @option arguments [Hash] :body The settings to be updated. Can be either `transient` or `persistent` (survives cluster restart). (*Required*)
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-update-settings/
        #
        def put_settings(arguments={})
          method = HTTP_PUT
          path   = "_cluster/settings"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body] || {}

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:put_settings, [
            :flat_settings,
            :master_timeout,
            :timeout ].freeze)
      end
    end
  end
end
