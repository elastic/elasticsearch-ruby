module Elasticsearch
  module DSL
    module Search
      module Filters

        # GeoShape filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-geo-shape-filter.html
        #
        class GeoShape
          include BaseComponent

          option_method :shape
          option_method :indexed_shape
        end

      end
    end
  end
end
