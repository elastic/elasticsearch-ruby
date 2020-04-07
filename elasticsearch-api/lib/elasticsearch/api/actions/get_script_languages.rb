# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns available script types, languages and contexts
      #
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/modules-scripting.html
      #
      def get_script_languages(arguments = {})
        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        method = Elasticsearch::API::HTTP_GET
        path   = "_script_language"
        params = {}

        body = nil
        perform_request(method, path, params, body, headers).body
      end
    end
    end
end
