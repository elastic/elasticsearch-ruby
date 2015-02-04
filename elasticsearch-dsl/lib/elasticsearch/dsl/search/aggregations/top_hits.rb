module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # TopHits agg
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-top-hits-aggregation.html
        #
        class TopHits
          include BaseComponent

          option_method :from
          option_method :size
          option_method :sort
        end

      end
    end
  end
end
