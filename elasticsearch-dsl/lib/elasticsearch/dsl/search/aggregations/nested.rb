module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Nested agg
        #
        # @example
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-nested-aggregation.html
        #
        class Nested
          include BaseAggregationComponent

          option_method :path
        end

      end
    end
  end
end
