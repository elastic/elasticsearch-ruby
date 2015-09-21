module Elasticsearch
  module API
    module Cluster
      module Actions

        VALID_GET_SETTINGS_PARAMS = [ :flat_settings ].freeze

        # Get the cluster settings (previously set with {Cluster::Actions#put_settings})
        #
        # @example Get cluster settings
        #
        #     client.cluster.get_settings
        #
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-update-settings/
        #
        def get_settings(arguments={})
          get_settings_request_for(arguments).body
        end

        def get_settings_request_for(arguments={})
          method = HTTP_GET
          path   = "_cluster/settings"
          params = Utils.__validate_and_extract_params arguments, VALID_GET_SETTINGS_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
