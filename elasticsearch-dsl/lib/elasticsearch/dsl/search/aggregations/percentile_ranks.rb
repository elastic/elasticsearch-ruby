module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # PercentileRanks agg
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-percentile-rank-aggregation.html
        #
        class PercentileRanks
          include BaseComponent

          option_method :field
          option_method :values
          option_method :script
          option_method :params
          option_method :compression
        end

      end
    end
  end
end
