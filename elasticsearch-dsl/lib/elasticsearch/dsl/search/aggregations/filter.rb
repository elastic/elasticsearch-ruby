module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Filter agg
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-filters-aggregation.html
        #
        class Filter
          include BaseAggregationComponent
        end

      end
    end
  end
end
