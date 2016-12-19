module Elasticsearch
  module DSL
    module Search
      module Queries

        # A simple to use, yet sophisticated query which returns documents matching the specified terms,
        # taking into account field types, analyzers, etc. and allowing to search in phrase, prefix, fuzzy modes
        #
        # @example
        #
        #     search do
        #       query do
        #         match :content do
        #           query    'how to fix my printer'
        #           operator 'and'
        #         end
        #       end
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-query.html
        #
        class Match
          include BaseComponent

          option_method :query
          option_method :operator
          option_method :minimum_should_match
          option_method :type
          option_method :boost
          option_method :fuzziness
          option_method :prefix_length
          option_method :max_expansions
          option_method :fuzzy_rewrite
          option_method :analyzer
          option_method :lenient
          option_method :zero_terms_query
          option_method :cutoff_frequency
        end

      end
    end
  end
end
