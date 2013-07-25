module Elasticsearch
  module API
    module Actions

      # Return information if and how well a document matches a query.
      #
      # The returned information contains a `_score` and its explanation, if the document matches the query.
      #
      # @example Passing the query in the Lucene query syntax as the `:q` URL parameter
      #
      #     client.explain index: 'myindex', type: 'mytype', id: '1', q: 'test'
      #
      # @example Passing the query in the Query DSL as the request `:body`
      #
      #     client.explain index: 'myindex', type: 'mytype', id: '1',
      #                    body: { query: { match: { title: 'test' } } }
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [Hash] :body The query definition using the Query DSL (*Required*)
      # @option arguments [Boolean] :analyze_wildcard Specify whether wildcards and prefix queries in the query string
      #                                               query should be analyzed (default: false)
      # @option arguments [String] :analyzer The analyzer for the query string query
      # @option arguments [String] :default_operator The default operator for query string query (AND or OR)
      #                                              (options: AND, OR)
      # @option arguments [String] :df The default field for query string query (default: _all)
      # @option arguments [List] :fields A comma-separated list of fields to return in the response
      # @option arguments [Boolean] :lenient Specify whether format-based query failures
      #                                      (such as providing text to a numeric field) should be ignored
      # @option arguments [Boolean] :lowercase_expanded_terms Specify whether query terms should be lowercased
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [String] :q Query in the Lucene query string syntax
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :source The URL-encoded query definition (instead of using the request body)
      #
      # @see http://elasticsearch.org/guide/reference/api/explain/
      #
      def explain(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        method = 'GET'
        path   = Utils.__pathify( arguments[:index], arguments[:type], arguments[:id], '_explain' )
        params = arguments.select do |k,v|
          [ :analyze_wildcard,
            :analyzer,
            :default_operator,
            :df,
            :fields,
            :lenient,
            :lowercase_expanded_terms,
            :parent,
            :preference,
            :q,
            :routing,
            :source ].include?(k)
        end
        # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
        params = Hash[params] unless params.is_a?(Hash)
        body   = arguments[:body]

        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        perform_request(method, path, params, body).body
      end
    end
  end
end
