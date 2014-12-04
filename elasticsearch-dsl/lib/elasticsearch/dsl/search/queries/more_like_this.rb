module Elasticsearch
  module DSL
    module Search
      module Queries

        # MoreLikeThis query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-mlt-query.html
        #
        class MoreLikeThis
          include BaseComponent

          option_method :fields
          option_method :like_text
          option_method :min_term_freq
          option_method :max_query_terms
          option_method :docs
          option_method :ids
          option_method :include
          option_method :exclude
          option_method :percent_terms_to_match
          option_method :stop_words
          option_method :min_doc_freq
          option_method :max_doc_freq
          option_method :min_word_length
          option_method :max_word_length
          option_method :boost_terms
          option_method :boost
          option_method :analyzer
        end

      end
    end
  end
end
