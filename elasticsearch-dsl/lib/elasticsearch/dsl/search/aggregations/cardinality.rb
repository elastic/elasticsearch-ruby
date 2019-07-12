# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the approximate count of distinct values
        #
        # @example
        #
        #     search do
        #       aggregation :authors do
        #         cardinality do
        #           field 'author'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-cardinality-aggregation.html
        #
        class Cardinality
          include BaseComponent

          option_method :field
          option_method :precision_threshold
          option_method :rehash
          option_method :script
          option_method :params
        end

      end
    end
  end
end
