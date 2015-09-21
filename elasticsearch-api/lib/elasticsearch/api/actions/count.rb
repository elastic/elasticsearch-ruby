module Elasticsearch
  module API
    module Actions

      VALID_COUNT_PARAMS = [
        :ignore_unavailable,
        :allow_no_indices,
        :expand_wildcards,
        :min_score,
        :preference,
        :routing,
        :q,
        :analyzer,
        :analyze_wildcard,
        :default_operator,
        :df,
        :lenient,
        :lowercase_expanded_terms
      ].freeze

      # Get the number of documents for the cluster, index, type, or a query.
      #
      # @example Get the number of all documents in the cluster
      #
      #     client.count
      #
      # @example Get the number of documents in a specified index
      #
      #     client.count index: 'myindex'
      #
      # @example Get the number of documents matching a specific query
      #
      #     index: 'my_index', body: { filtered: { filter: { terms: { foo: ['bar'] } } } }
      #
      # @option arguments [List] :index A comma-separated list of indices to restrict the results
      # @option arguments [List] :type A comma-separated list of types to restrict the results
      # @option arguments [Hash] :body A query to restrict the results specified with the Query DSL (optional)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
      #                                                 unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves
      #                                               into no concrete indices.
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices
      #                                              that are open, closed or both.
      #                                              (options: open, closed, none, all)
      # @option arguments [Number] :min_score Include only documents with a specific `_score` value in the result
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :q Query in the Lucene query string syntax
      # @option arguments [String] :analyzer The analyzer to use for the query string
      # @option arguments [Boolean] :analyze_wildcard Specify whether wildcard and prefix queries should be
      #                                               analyzed (default: false)
      # @option arguments [String] :default_operator The default operator for query string query (AND or OR)
      #                                              (options: AND, OR)
      # @option arguments [String] :df The field to use as default where no field prefix is given in the query
      #                                string
      # @option arguments [Boolean] :lenient Specify whether format-based query failures (such as providing text
      #                                      to a numeric field) should be ignored
      # @option arguments [Boolean] :lowercase_expanded_terms Specify whether query terms should be lowercased
      #
      # @see http://elasticsearch.org/guide/reference/api/count/
      #
      def count(arguments={})
        count_request_for(arguments).body
      end

      def count_request_for(arguments={})
        method = HTTP_GET
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_count' )

        params = Utils.__validate_and_extract_params arguments, VALID_COUNT_PARAMS
        body   = arguments[:body]

        perform_request(method, path, params, body)
      end
    end
  end
end
