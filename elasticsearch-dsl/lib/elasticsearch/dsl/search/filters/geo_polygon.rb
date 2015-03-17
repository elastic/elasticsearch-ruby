module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which fall into a specified geographical polygon
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_polygon :location do
        #               points [
        #                [14.2244355,49.9419006],
        #                [14.2244355,50.1774301],
        #                [14.7067869,50.1774301],
        #                [14.7067869,49.9419006],
        #                [14.2244355,49.9419006]
        #               ]
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
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
