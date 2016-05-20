module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A parent pipeline aggregation which calculates the derivative of a specified metric in a parent histogram (or date_histogram) aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :tags do
        #       derivative buckets_path: 'tags'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :tags do
        #         derivative do
        #           buckets_path 'tags'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-derivative-aggregation.html
        #
        class Derivative
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
