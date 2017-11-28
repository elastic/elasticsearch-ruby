module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns the configured remote cluster information
        #
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/cluster-remote-info.html
        #
        def remote_info(arguments={})
          method = Elasticsearch::API::HTTP_GET
          path   = "_remote/info"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
