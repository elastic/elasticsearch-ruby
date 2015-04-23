module Elasticsearch
  module API
    module Actions

      # Abort a particular scroll search and clear all the resources associated with it.
      #
      # @option arguments [List] :scroll_id A comma-separated list of scroll IDs to clear;
      #                                     use `_all` clear all scroll search contexts
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-request-search-type.html#clear-scroll
      #
      def clear_scroll(arguments={})
        raise ArgumentError, "Required argument 'scroll_id' missing" unless arguments[:scroll_id]

        scroll_id = arguments[:body] || arguments.delete(:scroll_id)

        scroll_ids = case scroll_id
          when Array
            scroll_id.join(',')
          else
            scroll_id
        end

        method = HTTP_DELETE
        path   = Utils.__pathify '_search/scroll'
        params = {}
        body   = scroll_ids

        perform_request(method, path, params, body).body
      end
    end
  end
end
