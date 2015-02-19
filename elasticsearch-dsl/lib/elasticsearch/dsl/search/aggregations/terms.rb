module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Terms aggregation
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html
        #
        class Terms
          include BaseAggregationComponent

          option_method :field
          option_method :size
          option_method :shard_size
          option_method :order
          option_method :min_doc_count
          option_method :shard_min_doc_count
          option_method :script
          option_method :include
          option_method :exclude
        end

      end
    end
  end
end
