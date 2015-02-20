module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # DateRange aggregation
        #
        # @example
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
