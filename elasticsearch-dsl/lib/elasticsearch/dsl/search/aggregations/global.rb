# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Defines a single bucket of all the documents matching a query
        #
        # @example
        #
        #     search do
        #       aggregation :all_documents do
        #         global do
        #           aggregation :avg_clicks do
        #             avg field: 'clicks'
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-global-aggregation.html
        #
        class Global
          include BaseAggregationComponent
        end

      end
    end
  end
end
