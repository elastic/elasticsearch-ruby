module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A parent pipeline aggregation which executes a script which can perform per bucket computations on specified metrics in the parent multi-bucket aggregation.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :tags do
        #       bucket_script buckets_path: { foo: 'foo', bar: 'bar' }, script: 'baz'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :tags do
        #         bucket_script do
        #           buckets_path foo: 'foo', bar: 'bar'
        #           script 'baz'
        #         end
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
