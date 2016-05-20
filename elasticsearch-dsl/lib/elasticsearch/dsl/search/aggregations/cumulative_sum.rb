module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A parent pipeline aggregation which calculates the cumulative sum of a specified metric in a parent histogram (or date_histogram) aggregation. 
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :tags do
        #       cumulative_sum buckets_path: 'tags'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :tags do
        #         cumulative_sum do
        #           buckets_path 'tags'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-cumulative-sum-aggregation.html
        #
        class CumulativeSum
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :format
        end
      end
    end
  end
end
