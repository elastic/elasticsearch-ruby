module Elasticsearch
  module API
    module Cluster
      module Actions

        # Update cluster settings.
        #
        # @option arguments [Hash] :body The settings to be updated. Can be either `transient` or `persistent`
        #                                (survives cluster restart).
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-update-settings/
        #
        def put_settings(arguments={})
          method = 'PUT'
          path   = "_cluster/settings"
          params = {}
          body   = arguments[:body] || {}

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
