module Elasticsearch
  module DSL
    module Search
      module Queries

        # Term query
        #
        # @example
        #
        #     query do
        #       term message: 'test'
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-query.html
        #
        class Term
          include BaseComponent
        end

      end
    end
  end
end
