module Elasticsearch
  module DSL
    module Search
      module Queries

        # Range query
        #
        # @example
        #
        #     query do
        #       range :age do
        #         gte 10
        #         lte 20
        #       end
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-query.html
        #
        class Range
          include BaseComponent

          option_method :gte
          option_method :gt
          option_method :lte
          option_method :lt
          option_method :boost
        end

      end
    end
  end
end
