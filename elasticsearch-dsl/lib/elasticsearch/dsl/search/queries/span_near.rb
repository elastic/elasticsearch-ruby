module Elasticsearch
  module DSL
    module Search
      module Queries

        # SpanNear query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-span-near-query.html
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
