module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # IpRange aggregation
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-iprange-aggregation.html
        #
        class IpRange
          include BaseAggregationComponent

          option_method :field
          option_method :ranges
        end

      end
    end
  end
end
