module Elasticsearch
  module API
    module Actions

      # Perform multiple search operations in a single request.
      #
      # Pass the search definitions in the `:body` argument
      #
      # @example Perform multiple different searches as `:search`
      #
      #     client.msearch \
      #       body: [
      #         { search: { query: { match_all: {} } } },
      #         { index: 'myindex', type: 'mytype', search: { query: { query_string: { query: '"Test 1"' } } } },
      #         { search_type: 'count', search: { aggregations: { published: { terms: { field: 'published' } } } } }
      #       ]
      #
      # @example Perform multiple different searches as an array of meta/data pairs
      #
      #     client.msearch \
      #       body: [
      #         { query: { match_all: {} } },
      #         { index: 'myindex', type: 'mytype' },
      #         { query: { query_string: { query: '"Test 1"' } } },
      #         { search_type: 'count' },
      #         { aggregations: { published: { terms: { field: 'published' } } } }
      #       ]
      #
      # @option arguments [List] :index A comma-separated list of index names to use as default
      # @option arguments [List] :type A comma-separated list of document types to use as default
      # @option arguments [Array<Hash>] :body An array of request definitions, each definition is a Hash;
      #                                       pass the search definition as a `:search` argument
      # @option arguments [String] :search_type Search operation type (options: query_then_fetch, query_and_fetch,
      #                                         dfs_query_then_fetch, dfs_query_and_fetch, count, scan)
      #
      # @see http://www.elasticsearch.org/guide/reference/api/multi-search/
      #
      def msearch(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        valid_params = [ :search_type ]

        method = HTTP_GET
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_msearch' )

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        case
        when body.is_a?(Array) && body.any? { |d| d.has_key? :search }
          payload = body.
            inject([]) do |sum, item|
              meta = item
              data = meta.delete(:search)

              sum << meta
              sum << data
              sum
            end.
            map { |item| MultiJson.dump(item) }
          payload << "" unless payload.empty?
          payload = payload.join("\n")
        when body.is_a?(Array)
          payload = body.map { |d| d.is_a?(String) ? d : MultiJson.dump(d) }
          payload << "" unless payload.empty?
          payload = payload.join("\n")
        else
          payload = body
        end

        perform_request(method, path, params, payload).body
      end
    end
  end
end
