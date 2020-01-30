# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Explicitly clears the search context for a scroll.
      #
      # @option arguments [List] :scroll_id A comma-separated list of scroll IDs to clear   *Deprecated*

      # @option arguments [Hash] :body A comma-separated list of scroll IDs to clear if none was specified via the scroll_id parameter
      #
      # *Deprecation notice*:
      # A scroll id can be quite large and should be specified as part of the body
      # Deprecated since version 7.0.0
      #
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/search-request-body.html#_clear_scroll_api
      #
      def clear_scroll(arguments = {})
        arguments = arguments.clone

        _scroll_id = arguments.delete(:scroll_id)

        method = HTTP_DELETE
        path   = if _scroll_id
                   "_search/scroll/#{Utils.__listify(_scroll_id)}"
                 else
                   "_search/scroll"
end
        params = {}

        body = arguments[:body]
        perform_request(method, path, params, body).body
      end
    end
    end
end
