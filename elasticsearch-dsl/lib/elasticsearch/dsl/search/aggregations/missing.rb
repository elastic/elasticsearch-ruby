module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which returns the collection of terms and their document counts
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :tags do
        #       missing field: 'tags'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :tags do
        #         missing do
        #           field 'tags'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/search-aggregations-bucket-missing-aggregation.html
        #
        class Missing
          include BaseAggregationComponent

          option_method :field
        end

      end
    end
  end
end
