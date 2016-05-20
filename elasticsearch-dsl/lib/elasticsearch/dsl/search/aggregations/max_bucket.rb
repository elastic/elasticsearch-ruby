module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A sibling pipeline aggregation which identifies the bucket(s) with the maximum value of a specified metric in a sibling aggregation and outputs both the value and the key(s) of the bucket(s).
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :tags do
        #       max_bucket buckets_path: 'tags'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :tags do
        #         max_bucket do
        #           buckets_path 'tags'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-max-bucket-aggregation.html
        #
        class MaxBucket
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
