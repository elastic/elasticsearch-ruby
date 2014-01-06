module Elasticsearch
  module API
    module Actions

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
      # @option arguments [Hash] :body A query to restrict the results (optional)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
      #                                               no concrete indices. (This includes `_all` string or when no
      #                                               indices have been specified)
      # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
      #                                            `missing` ones (options: none, missing) @until 1.0
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
      #                                                 unavailable (missing, closed, etc)
      # @option arguments [Number] :min_score Include only documents with a specific `_score` value in the result
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :source The URL-encoded query definition (instead of using the request body)
      #
      # @see http://elasticsearch.org/guide/reference/api/count/
      #
      def count(arguments={})
        valid_params = [
          :ignore_indices,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :min_score,
          :preference,
          :routing,
          :source ]

        method = 'GET'
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_count' )

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
