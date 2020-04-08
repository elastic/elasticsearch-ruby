# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Allows to use the Mustache language to pre-render a search definition.
      #
      # @option arguments [String] :id The id of the stored search template
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The search definition template and its params
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-template.html#_validating_templates
      #
      def render_search_template(arguments = {})
        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        _id = arguments.delete(:id)

        method = Elasticsearch::API::HTTP_GET
        path   = if _id
                   "_render/template/#{Utils.__listify(_id)}"
                 else
                   "_render/template"
    end
        params = {}

        body = arguments[:body]
        perform_request(method, path, params, body, headers).body
      end
    end
    end
end
