module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Filters agg
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-filters-aggregation.html
        #
        class Filters
          include BaseAggregationComponent

          option_method :filters
        end

      end
    end
  end
end
