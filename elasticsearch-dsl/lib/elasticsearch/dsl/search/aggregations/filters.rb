module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-bucket aggregation which defines multiple buckets matching the provided filters,
        # usually to define scope for a nested aggregation
        #
        # @example
        #
        #    search do
        #      aggregation :avg_clicks_per_tag_one_and_two do
        #        filters do
        #          filters one: { terms: { tags: ['one'] } },
        #                  two: { terms: { tags: ['two'] } }
        #
        #          aggregation :avg do
        #            avg field: 'clicks'
        #          end
        #        end
        #      end
        #    end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-filters-aggregation.html
        #
        class Filters
          include BaseAggregationComponent

          option_method :filters
        end

      end
    end
  end
end
