module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # GeoDistance aggregation
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geo-distance-agg.html
        #
        class GeoDistance
          include BaseAggregationComponent

          option_method :field
          option_method :origin
          option_method :ranges
          option_method :unit
          option_method :distance_type
        end

      end
    end
  end
end
