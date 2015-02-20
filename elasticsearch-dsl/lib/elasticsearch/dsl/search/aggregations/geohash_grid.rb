module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # GeohashGrid aggregation
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/geohash-grid-agg.html
        #
        class GeohashGrid
          include BaseAggregationComponent

          option_method :field
          option_method :precision
          option_method :size
          option_method :shard_size
        end

      end
    end
  end
end
