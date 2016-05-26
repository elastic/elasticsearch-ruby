module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A parent pipeline aggregation which executes a script which can perform per bucket computations on specified metrics in the parent multi-bucket aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :t-shirt-percentage do
        #       bucket_script buckets_path: { tShirtSales: 't-shirts>sales', totalSales: 'total_sales' }, script: 'tShirtSales / totalSales * 100'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :t-shirt-percentage do
        #       bucket_script do
        #         buckets_path tShirtSales: 't-shirts>sales', totalSales: 'total_sales'
        #         script 'tShirtSales / totalSales * 100'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-bucket-script-aggregation.html
        #
        class BucketScript
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :script
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
