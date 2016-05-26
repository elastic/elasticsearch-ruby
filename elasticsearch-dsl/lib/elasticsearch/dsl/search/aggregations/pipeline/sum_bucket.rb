module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A sibling pipeline aggregation which calculates the sum across all bucket of a specified metric in a sibling aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :sum_monthly_sales do
        #       sum_bucket buckets_path: 'sales_per_month>sales'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :sum_monthly_sales do
        #       sum_bucket do
        #         buckets_path 'sales_per_month>sales'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-sum-bucket-aggregation.html
        #
        class SumBucket
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
