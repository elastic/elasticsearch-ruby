module Elasticsearch
  module DSL
    module Search
      module Queries

        # MatchAll query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/_most_important_queries_and_filters.html
        #
        class MatchAll
          include BaseComponent

          option_method :boost
        end

      end
    end
  end
end
