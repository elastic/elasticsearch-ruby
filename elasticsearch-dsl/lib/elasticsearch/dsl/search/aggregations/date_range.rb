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
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-daterange-aggregation.html
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
