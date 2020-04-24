# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions

      # Retrieve an indexed script from Elasticsearch
      #
      # @option arguments [String] :id Template ID (*Required*)
      # @option arguments [Hash] :body The document
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-template.html
      #
      def get_template(arguments={})
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
        method = HTTP_GET
        path   = "_scripts/#{arguments[:id]}"
        params = {}
        body   = arguments[:body]

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
        else
          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
