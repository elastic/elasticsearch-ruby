module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A multi-value metrics aggregation which returns statistical information on numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :clicks_stats do
        #         stats field: 'clicks'
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-stats-aggregation.html
        #
        class Stats
          include BaseComponent
        end

      end
    end
  end
end
