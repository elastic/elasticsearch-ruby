# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-value metrics aggregation which returns statistical information on numeric values
        #
        # @example Passing the options as a Hash
        #
        #     search do
        #       aggregation :clicks_stats do
        #         stats field: 'clicks'
        #       end
        #     end
        #
        # @example Passing the options as a block
        #
        #     search do
        #       aggregation :clicks_stats do
        #         stats do
        #           field 'clicks'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-stats-aggregation.html
        #
        class Stats
          include BaseComponent

          option_method :field
          option_method :script
        end

      end
    end
  end
end
