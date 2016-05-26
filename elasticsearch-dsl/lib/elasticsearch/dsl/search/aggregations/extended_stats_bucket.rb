module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A sibling pipeline aggregation which calculates a variety of stats across all bucket of a specified metric in a sibling aggregation. The specified metric must be numeric and the sibling aggregation must be a multi-bucket aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :stats_monthly_sales do
        #       extended_stats_bucket buckets_path: 'sales_per_month>sales'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :stats_monthly_sales do
        #       extended_stats_bucket do
        #         buckets_path 'sales_per_month>sales'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-extended-stats-bucket-aggregation.html
        #
        class ExtendedStatsBucket
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
