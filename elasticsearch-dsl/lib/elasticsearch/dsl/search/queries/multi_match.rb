module Elasticsearch
  module DSL
    module Search
      module Queries

        # MultiMatch query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html
        #
        class MultiMatch
          include BaseComponent

          option_method :query
          option_method :fields
          option_method :type
          option_method :use_dis_max
        end

      end
    end
  end
end
