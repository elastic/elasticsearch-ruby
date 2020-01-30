# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns basic information about the cluster.
      #

      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
      #
      def info(arguments = {})
        arguments = arguments.clone

        method = HTTP_GET
        path   = ""
        params = {}

        body = nil
        perform_request(method, path, params, body).body
      end
    end
    end
end
