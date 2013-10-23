module Elasticsearch
  module API
    module Actions

      # Delete documents which match specified query.
      #
      # Provide the query either as a "query string" query in the `:q` argument, or using the Elasticsearch's
      # [Query DSL](http://www.elasticsearch.org/guide/reference/query-dsl/) in the `:body` argument.
      #
      # @example Deleting documents with a simple query
      #
      #     client.delete_by_query index: 'myindex', q: 'title:test'
      #
      # @example Deleting documents using the Query DSL
      #
      #     client.delete_by_query index: 'myindex', body: { term: { published: false } }
      #
      # @option arguments [List] :index A comma-separated list of indices to restrict the operation;
      #                                 use `_all`to perform the operation on all indices (*Required*)
      # @option arguments [List] :type A comma-separated list of types to restrict the operation
      # @option arguments [Hash] :body A query to restrict the operation
      # @option arguments [String] :analyzer The analyzer to use for the query string
      # @option arguments [String] :consistency Specific write consistency setting for the operation
      #                                         (options: one, quorum, all)
      # @option arguments [String] :default_operator The default operator for query string query (AND or OR)
      #                                              (options: AND, OR)
      # @option arguments [String] :df The field to use as default where no field prefix is given in the query string
      # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
      #                                            (options: none, missing)
      # @option arguments [String] :replication Specific replication type (options: sync, async)
      # @option arguments [String] :q Query in the Lucene query string syntax
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :source The URL-encoded query definition (instead of using the request body)
      # @option arguments [Time] :timeout Explicit operation timeout
      #
      # @see http://www.elasticsearch.org/guide/reference/api/delete-by-query/
      #
      def delete_by_query(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        valid_params = [
          :analyzer,
          :consistency,
          :default_operator,
          :df,
          :ignore_indices,
          :replication,
          :q,
          :routing,
          :source,
          :timeout ]

        method = 'DELETE'
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), '/_query' )

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
