module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A sibling pipeline aggregation which calculates the (mean) average value of a specified metric in a sibling aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :avg_monthly_sales do
        #       avg_bucket buckets_path: 'sales_per_month>sales'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :avg_monthly_sales do
        #       avg_bucket do
        #         buckets_path 'sales_per_month>sales'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-avg-bucket-aggregation.html
        #
        class AvgBucket
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
