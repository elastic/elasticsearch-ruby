# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # Defines a single bucket with documents matching the provided filter,
        # usually to define scope for a nested aggregation
        #
        # @example
        #
        #    search do
        #      aggregation :clicks_for_tag_one do
        #        filter terms: { tags: ['one'] } do
        #          aggregation :sum_clicks do
        #            sum field: 'clicks'
        #          end
        #        end
        #      end
        #    end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-filters-aggregation.html
        #
        class Filter
          include BaseAggregationComponent
        end

      end
    end
  end
end
