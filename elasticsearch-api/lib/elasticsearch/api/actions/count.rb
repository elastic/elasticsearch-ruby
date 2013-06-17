module Elasticsearch
  module API
    module Actions

      # Get the number of documents for the cluster, index, type, or a query.
      #
      # @option arguments [List] :index A comma-separated list of indices to restrict the results
      # @option arguments [List] :type A comma-separated list of types to restrict the results
      # @option arguments [Hash] :body A query to restrict the results (optional)
      # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
      #                                            (options: none, missing)
      # @option arguments [Number] :min_score Include only documents with a specific `_score` value in the result
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :source The URL-encoded query definition (instead of using the request body)
      #
      # @see http://elasticsearch.org/guide/reference/api/count/
      #
      def count(arguments={})
        method = 'GET'
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), Utils.__listify(arguments[:type]), '_count' )
        params = arguments.select do |k,v|
          [ :ignore_indices,
            :min_score,
            :preference,
            :routing,
            :source ].include?(k)
        end
        # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
        params = Hash[params] unless params.is_a?(Hash)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
