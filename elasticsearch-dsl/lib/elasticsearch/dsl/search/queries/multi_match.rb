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

          option_method :analyzer
          option_method :boost
          option_method :cutoff_frequency
          option_method :fields
          option_method :fuzziness
          option_method :max_expansions
          option_method :minimum_should_match
          option_method :operator
          option_method :prefix_length
          option_method :query
          option_method :rewrite
          option_method :slop
          option_method :type
          option_method :use_dis_max
          option_method :zero_terms_query
        end

      end
    end
  end
end
