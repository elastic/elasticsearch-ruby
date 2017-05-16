module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A parent pipeline aggregation which calculates the cumulative sum of a specified metric in a parent histogram (or date_histogram) aggregation. 
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :cumulative_sales do
        #       cumulative_sum buckets_path: 'sales'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :cumulative_sales do
        #       cumulative_sum do
        #         buckets_path 'sales'
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
