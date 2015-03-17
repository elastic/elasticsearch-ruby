module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns documents matching spans near each other
        #
        # @example
        #
        #     search do
        #       query do
        #         span_near clauses: [ { span_term: { title: 'disaster' } }, { span_term: { title: 'health' } } ],
        #                   slop: 10
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-span-near-query.html
        # @see https://lucene.apache.org/core/5_0_0/core/org/apache/lucene/search/spans/package-summary.html
        #
        class SpanNear
          include BaseComponent

          option_method :span_near
          option_method :slop
          option_method :in_order
          option_method :collect_payloads
        end

      end
    end
  end
end
