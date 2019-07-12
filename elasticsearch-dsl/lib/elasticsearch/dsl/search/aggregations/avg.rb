# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the average of numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :avg_clicks do
        #         avg field: 'clicks'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-avg-aggregation.html
        #
        class Avg
          include BaseComponent
        end

      end
    end
  end
end
