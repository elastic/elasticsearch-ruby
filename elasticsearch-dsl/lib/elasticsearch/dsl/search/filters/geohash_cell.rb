module Elasticsearch
  module DSL
    module Search
      module Filters

        # GeohashCell filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geohash-cell-filter.html
        #
        class GeohashCell
          include BaseComponent

          option_method :lat
          option_method :lon
        end

      end
    end
  end
end
