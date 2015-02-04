module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # ReverseNested aggregation
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/nested-aggregation.html
        #
        class ReverseNested
          include BaseAggregationComponent
        end

      end
    end
  end
end
