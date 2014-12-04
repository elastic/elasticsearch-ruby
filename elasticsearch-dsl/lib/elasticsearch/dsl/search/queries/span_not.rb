module Elasticsearch
  module DSL
    module Search
      module Queries

        # SpanNot query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-span-not-query.html
        #
        class SpanNot
          include BaseComponent

          option_method :include
          option_method :exclude
          option_method :pre
          option_method :post
          option_method :dist
        end

      end
    end
  end
end
