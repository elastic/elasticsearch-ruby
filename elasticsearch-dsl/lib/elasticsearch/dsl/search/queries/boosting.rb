module Elasticsearch
  module DSL
    module Search
      module Queries

        # Boosting query
        #
        # @example
        #
        #     query do
        #       boosting do
        #         positive term: { title: 'john' }
        #         negative term: { title: 'dave' }
        #         negative_boost 0.2
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-boosting-query.html
        #
        class Boosting
          include BaseComponent

          option_method :positive
          option_method :negative
          option_method :negative_boost
        end

      end
    end
  end
end
