module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Children aggregation
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-children-aggregation.html
        #
        class Children
          include BaseAggregationComponent

          option_method :type
        end

      end
    end
  end
end
