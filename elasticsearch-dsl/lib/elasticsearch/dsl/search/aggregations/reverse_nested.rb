module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-bucket aggregation which allows to aggregate on "parent" documents
        # from the nested documents
        #
        # @example
        #
        #     search do
        #       aggregation :offers do
        #         nested do
        #           path 'offers'
        #           aggregation :top_categories do
        #             reverse_nested do
        #               aggregation :top_category_per_offer do
        #                 terms field: 'category'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a full example.
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/nested-aggregation.html
        #
        class ReverseNested
          include BaseAggregationComponent
        end

      end
    end
  end
end
