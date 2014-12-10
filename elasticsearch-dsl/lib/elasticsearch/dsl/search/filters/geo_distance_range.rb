module Elasticsearch
  module DSL
    module Search
      module Filters

        # GeoDistanceRange filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geo-distance.html
        #
        class GeoDistanceRange
          include BaseComponent

          option_method :lat
          option_method :lon
        end

      end
    end
  end
end
