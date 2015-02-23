module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the number of values for the aggregation scope
        #
        # @example
        #
        #     search do
        #       aggregation :value_count do
        #         value_count field: 'clicks'
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-valuecount-aggregation.html
        #
        class ValueCount
          include BaseComponent
        end

      end
    end
  end
end
