# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions

      # Retrieve an indexed template from Elasticsearch
      #
      # @option arguments [String] :id Template ID
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-template.html
      #
      def delete_template(arguments={})
        method = HTTP_DELETE
        path   = "_search/template/#{arguments[:id]}"
        params = {}
        body   = nil

        perform_request(method, path, params, body).body
      end
    end
  end
end
