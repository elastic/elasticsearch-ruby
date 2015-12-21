module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which returns the collection of terms and their document counts
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :tags do
        #       terms field: 'tags'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :tags do
        #         terms do
        #           field 'tags'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html
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
