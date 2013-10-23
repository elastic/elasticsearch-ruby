module Elasticsearch
  module API
    module Actions

      # Efficiently iterate over a large result set.
      #
      # When using `from` and `size` to return a large result sets, performance drops as you "paginate" in the set,
      # and you can't guarantee the consistency when the index is being updated at the same time.
      #
      # "Scrolling" the results is frequently used with the `scan` search type.
      #
      # @example Scroll results
      #
      #     result = client.search index: 'scrollindex',
      #                            scroll: '5m',
      #                            body: { query: { match: { title: 'test' } }, sort: '_id' }
      #
      #     client.scroll scroll: '5m', scroll_id: result['_scroll_id']
      #
      # @option arguments [String] :scroll_id The scroll ID
      # @option arguments [Hash] :body The scroll ID if not passed by URL or query parameter.
      # @option arguments [Duration] :scroll Specify how long a consistent view of the index
      #                                      should be maintained for scrolled search
      # @option arguments [String] :scroll_id The scroll ID for scrolled search
      #
      # @see http://www.elasticsearch.org/guide/reference/api/search/scroll/
      # @see http://www.elasticsearch.org/guide/reference/api/search/search-type/
      #
      def scroll(arguments={})
        method = 'GET'
        path   = "_search/scroll"
        valid_params = [
          :scroll,
          :scroll_id ]

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
