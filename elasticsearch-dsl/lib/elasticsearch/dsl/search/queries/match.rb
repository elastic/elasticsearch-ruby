module Elasticsearch
  module DSL
    module Search
      module Queries

        # Match query
        #
        # @example
        #
        #     query do
        #       match :message do
        #         query    'test'
        #         operator 'and'
        #         boost    2
        #       end
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-query.html
        #
        class Match
          include BaseComponent

          option_method :query
          option_method :operator
          option_method :boost
        end

      end
    end
  end
end
