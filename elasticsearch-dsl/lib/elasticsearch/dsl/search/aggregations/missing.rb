module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single bucket aggregation that creates a bucket of all documents
        # which are missing a value for the field
        #
        # @example Passing the options as a Hash
        #
        #     aggregation :articles_without_tags do
        #       missing field: 'tags'
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :articles_without_tags do
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
