# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions

      # Abort a particular scroll search and clear all the resources associated with it.
      #
      # @option arguments [List] :scroll_id A comma-separated list of scroll IDs to clear
      # @option arguments [Hash] :body A comma-separated list of scroll IDs to clear if none was specified via the scroll_id parameter
      #
      # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/search-request-scroll.html
      #
      def clear_scroll(arguments={})
        method = Elasticsearch::API::HTTP_DELETE
        path   = Utils.__pathify '_search/scroll', Utils.__listify(arguments.delete(:scroll_id))
        params = {}
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
