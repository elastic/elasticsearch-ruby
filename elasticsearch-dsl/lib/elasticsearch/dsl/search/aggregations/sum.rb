# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the sum of numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :sum_clicks do
        #         sum field: 'clicks'
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-sum-aggregation.html
        #
        class Sum
          include BaseComponent
        end

      end
    end
  end
end
