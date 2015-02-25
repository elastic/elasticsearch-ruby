module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns documents matching a multi-term query as a span query
        #
        # @example
        #
        #     search do
        #       query do
        #         span_multi match: { prefix: { name: 'jo' } }
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-span-multi-term-query.html
        # @see https://lucene.apache.org/core/5_0_0/core/org/apache/lucene/search/spans/package-summary.html
        #
        class SpanMulti
          include BaseComponent

          option_method :match
        end

      end
    end
  end
end
