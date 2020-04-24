# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-value metrics aggregation which calculates percentiles on numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :load_time_outliers do
        #         percentiles do
        #           field 'load_time'
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-percentile-aggregation.html
        #
        class Percentiles
          include BaseComponent

          option_method :field
          option_method :percents
          option_method :script
          option_method :params
          option_method :compression
        end

      end
    end
  end
end
