module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-bucket aggregation which allows to aggregate from buckets on parent documents
        # to buckets on the children documents
        #
        # @example Return the top commenters per article category
        #
        #     search do
        #       aggregation :top_categories do
        #         terms field: 'category' do
        #           aggregation :comments do
        #             children type: 'comment' do
        #               aggregation :top_authors do
        #                 terms field: 'author'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        #
        # See the integration test for a full example.
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-children-aggregation.html
        #
        class Children
          include BaseAggregationComponent

          option_method :type
        end

      end
    end
  end
end
