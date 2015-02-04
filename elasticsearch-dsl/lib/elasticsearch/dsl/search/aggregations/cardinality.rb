module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Cardinality agg
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-cardinality-aggregation.html
        #
        class Cardinality
          include BaseComponent

          option_method :field
          option_method :precision_threshold
          option_method :rehash
          option_method :script
          option_method :params
        end

      end
    end
  end
end
