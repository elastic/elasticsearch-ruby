module Elasticsearch
  module DSL
    module Search
      module Queries

        # SpanFirst query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-span-first-query.html
        #
        class SpanFirst
          include BaseComponent

          option_method :match
        end

      end
    end
  end
end
