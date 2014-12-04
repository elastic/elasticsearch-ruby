module Elasticsearch
  module DSL
    module Search
      module Queries

        # Indices query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-indices-query.html
        #
        class Indices
          include BaseComponent

          option_method :indices
          option_method :query
          option_method :no_match_query
        end

      end
    end
  end
end
