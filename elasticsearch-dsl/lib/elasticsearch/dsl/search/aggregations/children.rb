# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-children-aggregation.html
        #
        class Children
          include BaseAggregationComponent

          option_method :type
        end

      end
    end
  end
end
