module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the maximum value from numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :max_clicks do
        #         max field: 'clicks'
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-max-aggregation.html
        #
        class Max
          include BaseComponent
        end

      end
    end
  end
end
