module Elasticsearch
  module DSL
    module Search
      module Queries

        # SpanMulti query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-span-multi-term-query.html
        #
        class SpanMulti
          include BaseComponent

          option_method :match
        end

      end
    end
  end
end
