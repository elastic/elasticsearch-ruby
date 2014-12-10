module Elasticsearch
  module DSL
    module Search
      module Filters

        # GeoBoundingBox filter
        #
        # @example
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
