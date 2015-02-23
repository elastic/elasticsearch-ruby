module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the minimum value from numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :min_clicks do
        #         min field: 'clicks'
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-min-aggregation.html
        #
        class Min
          include BaseComponent
        end

      end
    end
  end
end
