module Elasticsearch
  module API
    module Cluster
      module Actions

        VALID_PUT_SETTINGS_PARAMS = [ :flat_settings ].freeze

        # Update cluster settings.
        #
        # @example Disable shard allocation in the cluster until restart
        #
        #     client.cluster.put_settings body: { transient: { 'cluster.routing.allocation.disable_allocation' => true } }
        #
        # @option arguments [Hash] :body The settings to be updated. Can be either `transient` or `persistent`
        #                                (survives cluster restart).
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-update-settings/
        #
        def put_settings(arguments={})
          put_settings_request_for(arguments).body
        end

        def put_settings_request_for(arguments={})
          method = HTTP_PUT
          path   = "_cluster/settings"
          params = Utils.__validate_and_extract_params arguments, VALID_PUT_SETTINGS_PARAMS
          body   = arguments[:body] || {}

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
