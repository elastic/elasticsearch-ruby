module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Percentiles agg
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-percentile-aggregation.html
        #
        class Percentiles
          include BaseComponent

          option_method :field
          option_method :percents
          option_method :script
          option_method :params
          option_method :compression
        end

      end
    end
  end
end
