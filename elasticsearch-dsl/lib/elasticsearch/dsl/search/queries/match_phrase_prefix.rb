module Elasticsearch
  module DSL
    module Search
      module Queries

        # The same as match_phrase, except that it allows for prefix matches on the last term in the text
        #
        # @example
        #
        #     search do
        #       query do
        #         match_phrase_prefix :content do
        #           query 'example content'
        #           max_expansions 10
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query-phrase-prefix.html
        #
        class MatchPhrasePrefix
          include BaseComponent

          option_method :query
          option_method :boost
          option_method :max_expansions
        end

      end
    end
  end
end
