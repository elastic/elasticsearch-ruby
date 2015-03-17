module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # An aggregation which will calculate the smallest bounding box required to encapsulate
        # all of the documents matching the query
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_bounding_box :location do
        #               top_left     "40.8,-74.1"
        #               bottom_right "40.4,-73.9"
        #             end
        #           end
        #         end
        #       end
        #
        #       aggregation :new_york do
        #         geohash_grid field: 'location'
        #       end
        #
        #       aggregation :map_zoom do
        #         geo_bounds field: 'location'
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geo-bounds-agg.html
        #
        class GeoBounds
          include BaseComponent

          option_method :field
          option_method :wrap_longitude
        end

      end
    end
  end
end
