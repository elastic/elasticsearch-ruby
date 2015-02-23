module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which returns document counts for a defined numerical interval
        #
        # @example
        #
        #    search do
        #      aggregation :age do
        #        histogram do
        #          field   'age'
        #          interval 5
        #        end
        #      end
        #    end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-histogram-aggregation.html
        #
        class Histogram
          include BaseAggregationComponent

          option_method :field
          option_method :interval
          option_method :min_doc_count
          option_method :extended_bounds
          option_method :order
          option_method :keyed
        end

      end
    end
  end
end
