# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which returns document counts for custom date ranges
        #
        # @example
        #
        #     search do
        #       aggregation :compare_to_last_year do
        #         date_range do
        #           field    'published_at'
        #           ranges [
        #             { from: 'now-1M/M', to: 'now/M' },
        #             { from: 'now-13M/M', to: 'now-12M/M' }
        #           ]
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-daterange-aggregation.html
        #
        class DateRange
          include BaseAggregationComponent

          option_method :field
          option_method :format
          option_method :ranges
        end
      end
    end
  end
end
