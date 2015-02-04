module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # GeoBounds agg
        #
        # @example
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
