module Elasticsearch
  module DSL
    module Search
      module Filters

        # GeoPolygon filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-geo-polygon-filter.html
        #
        class GeoPolygon
          include BaseComponent

          option_method :points
        end

      end
    end
  end
end
