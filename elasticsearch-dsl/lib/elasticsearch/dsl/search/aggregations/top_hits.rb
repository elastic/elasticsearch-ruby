module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # A metric aggregator which returns the most relevant documents per bucket
        #
        # @example
        #
        #     search do
        #       aggregation :tags do
        #         terms do
        #           field 'tags'
        #
        #           aggregation :top_hits do
        #             top_hits sort: [ clicks: { order: 'desc' } ], _source: { include: 'title' }
        #           end
        #         end
        #       end
        #     end
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
