module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Given an ordered series of data, the Moving Average aggregation will slide a window across the data and emit the average value of that window. 
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :tags do
        #       moving_avg buckets_path: 'tags'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :tags do
        #         moving_avg do
        #           buckets_path 'tags'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-movavg-aggregation.html
        #
        class MovingAvg
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :model
          option_method :gap_policy
          option_method :window
          option_method :format
          option_method :minimize
          option_method :settings
        end
      end
    end
  end
end
