# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns basic information about the cluster.
      #
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/index.html
      #
      def info(arguments = {})
        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        method = Elasticsearch::API::HTTP_GET
        path   = ""
        params = {}

        body = nil
        perform_request(method, path, params, body, headers).body
      end
    end
    end
end
