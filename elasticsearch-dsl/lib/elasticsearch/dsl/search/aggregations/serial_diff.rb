module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Serial differencing is a technique where values in a time series are subtracted from itself at different time lags or periods.
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :thirtieth_difference do
        #       serial_diff buckets_path: 'the_sum'
        #     end
        #
        # @example Passing the options as a block
        #
        #     aggregation :thirtieth_difference do
        #       serial_diff do
        #         buckets_path 'the_sum'
        #         lag 30
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-pipeline-serialdiff-aggregation.html
        #
        class SerialDiff
          include BaseAggregationComponent

          option_method :buckets_path
          option_method :lag
          option_method :gap_policy
          option_method :format
        end
      end
    end
  end
end
