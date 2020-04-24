# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cluster
      module Actions

        # Returns the configured remote cluster information
        #
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-remote-info.html
        #
        def remote_info(arguments={})
          method = Elasticsearch::API::HTTP_GET
          path   = "_remote/info"
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:remote_info, [
        ].freeze)
      end
    end
  end
end
