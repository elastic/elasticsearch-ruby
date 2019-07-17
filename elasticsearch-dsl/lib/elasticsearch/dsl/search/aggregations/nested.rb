# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A single-bucket aggregation which allows to aggregate on nested fields
        #
        # @example
        #
        #    search do
        #      aggregation :offers do
        #        nested do
        #          path 'offers'
        #          aggregation :min_price do
        #            min field: 'offers.price'
        #          end
        #        end
        #      end
        #    end
        #
        # See the integration test for a full example.
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-nested-aggregation.html
        #
        class Nested
          include BaseAggregationComponent

          option_method :path
        end

      end
    end
  end
end
