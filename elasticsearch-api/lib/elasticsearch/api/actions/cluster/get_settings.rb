module Elasticsearch
  module API
    module Cluster
      module Actions

        # Get the cluster settings (previously set with {Cluster::Actions#put_settings})
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-cluster-update-settings/
        #
        def get_settings(arguments={})
          method = 'GET'
          path   = "_cluster/settings"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
