module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A sibling pipeline aggregation which identifies the bucket(s) with the minimum value of a specified metric in a sibling aggregation and outputs both the value and the key(s) of the bucket(s).
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :min_monthly_sales do
        #       min_bucket buckets_path: 'sales_per_month>sales'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :min_monthly_sales do
        #       min_bucket do
        #         buckets_path 'sales_per_month>sales'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-min-bucket-aggregation.html
        #
        class MinBucket
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
