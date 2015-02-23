module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the average of numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :avg_clicks do
        #         avg field: 'clicks'
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-avg-aggregation.html
        #
        class Avg
          include BaseComponent
        end

      end
    end
  end
end
