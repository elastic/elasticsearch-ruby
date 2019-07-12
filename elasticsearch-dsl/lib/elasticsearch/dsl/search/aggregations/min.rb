# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the minimum value from numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :min_clicks do
        #         min field: 'clicks'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-min-aggregation.html
        #
        class Min
          include BaseComponent
        end

      end
    end
  end
end
