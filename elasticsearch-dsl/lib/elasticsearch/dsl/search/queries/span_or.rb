module Elasticsearch
  module DSL
    module Search
      module Queries

        # SpanOr query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-span-or-query.html
        #
        class SpanOr
          include BaseComponent

          option_method :clauses
        end

      end
    end
  end
end
