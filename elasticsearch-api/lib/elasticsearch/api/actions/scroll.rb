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
      # @example A basic example
      #
      #     result = client.search index: 'scrollindex',
      #                            scroll: '5m',
      #                            body: { query: { match: { title: 'test' } }, sort: '_id' }
      #
      #     result = client.scroll scroll: '5m', scroll_id: result['_scroll_id']
      #
      # @example Call the `scroll` API until all the documents are returned
      #
      #     # Index 1,000 documents
      #     client.indices.delete index: 'test'
      #     1_000.times do |i| client.index index: 'test', type: 'test', id: i+1, body: {title: "Test #{i}"} end
      #     client.indices.refresh index: 'test'
      #
      #     # Open the "view" of the index with the `scan` search_type
      #     r = client.search index: 'test', search_type: 'scan', scroll: '5m', size: 10
      #
      #     # Call the `scroll` API until empty results are returned
      #     while r = client.scroll(scroll_id: r['_scroll_id'], scroll: '5m') and not r['hits']['hits'].empty? do
      #       puts "--- BATCH #{defined?($i) ? $i += 1 : $i = 1} -------------------------------------------------"
      #       puts r['hits']['hits'].map { |d| d['_source']['title'] }.inspect
      #       puts
      #     end
      #
      # @option arguments [String] :scroll_id The scroll ID
      # @option arguments [Hash] :body The scroll ID if not passed by URL or query parameter.
      # @option arguments [Duration] :scroll Specify how long a consistent view of the index
      #                                      should be maintained for scrolled search
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/scan-scroll.html#scan-scroll
      # @see http://www.elasticsearch.org/guide/reference/api/search/scroll/
      # @see http://www.elasticsearch.org/guide/reference/api/search/search-type/
      #
      def scroll(arguments={})
        method = HTTP_GET
        path   = "_search/scroll"
        valid_params = [
          :scroll,
          :scroll_id ]

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body] || params.delete(:scroll_id)

        perform_request(method, path, params, body).body
      end
    end
  end
end
