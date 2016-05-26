module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A parent pipeline aggregation which executes a script which determines whether the current bucket will be retained in the parent multi-bucket aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :sales_bucket_filter do
        #       bucket_selector buckets_path: { totalSales: 'total_sales' }, script: 'totalSales <= 50'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :sales_bucket_filter do
        #       bucket_selector do
        #         buckets_path totalSales: 'total_sales'
        #         script 'totalSales <= 50'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-bucket-selector-aggregation.html
        #
        class BucketSelector
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :script
          option_method :gap_policy
        end
      end
    end
  end
end
