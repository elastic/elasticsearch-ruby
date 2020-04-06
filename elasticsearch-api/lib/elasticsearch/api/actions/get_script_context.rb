# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns all script contexts.
      #

      #
      # @see https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-contexts.html
      #
      def get_script_context(arguments = {})
        arguments = arguments.clone

        method = Elasticsearch::API::HTTP_GET
        path   = "_script_context"
        params = {}

        body = nil
        perform_request(method, path, params, body).body
      end
    end
    end
end
