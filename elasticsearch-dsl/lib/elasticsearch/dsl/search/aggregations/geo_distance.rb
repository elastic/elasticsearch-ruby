module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which will return document counts for distance perimeters,
        # defined as ranges
        #
        # @example
        #
        #     search do
        #       aggregation :venue_distances do
        #         geo_distance do
        #           field  :location
        #           origin '38.9126352,1.4350621'
        #           unit   'km'
        #           ranges [ { to: 1 }, { from: 1, to: 5 }, { from: 5, to: 10 }, { from: 10 } ]
        #         end
        #       end
        #     end
        #
        # See the integration test for a full example.
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
