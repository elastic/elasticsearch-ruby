module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which allows to use the `match` query on multiple fields
        #
        # @example
        #
        #     search do
        #       query do
        #         multi_match do
        #           query    'how to fix my printer'
        #           fields   [:title, :abstract, :content]
        #           operator 'and'
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html
        #
        class MultiMatch
          include BaseComponent

          option_method :query
          option_method :fields
          option_method :operator
          option_method :type
          option_method :use_dis_max
        end

      end
    end
  end
end
