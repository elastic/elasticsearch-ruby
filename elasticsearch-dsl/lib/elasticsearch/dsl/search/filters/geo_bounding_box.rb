module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which fall into a "box" of the specified geographical coordinates
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_bounding_box :location do
        #               top_right   "50.1815123678,14.7149200439"
        #               bottom_left "49.9415476869,14.2162566185"
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
        #
        # Use eg. <http://boundingbox.klokantech.com> to visually define the bounding box.
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geo-bounding-box.html
        #
        class GeoBoundingBox
          include BaseComponent

          option_method :top_left
          option_method :bottom_right
          option_method :top_right
          option_method :bottom_left
          option_method :top
          option_method :left
          option_method :bottom
          option_method :right
        end

      end
    end
  end
end
