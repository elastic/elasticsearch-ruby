module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns documents which are similar to the specified text or documents
        #
        # @example Find documents similar to the provided text
        #
        #     search do
        #       query do
        #         more_like_this do
        #           like   ['Eyjafjallajökull']
        #           fields [:title, :abstract, :content]
        #         end
        #       end
        #     end
        #
        #
        # @example Find documents similar to the specified documents
        #
        #     search do
        #       query do
        #         more_like_this do
        #           like   [{_id: 1}, {_id: 2}, {_id: 3}]
        #           fields [:title, :abstract]
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-mlt-query.html
        #
        class MoreLikeThis
          include BaseComponent

          # like/unlike is since 2.0.0
          option_method :like
          option_method :unlike

          # before 2.0.0 the following 3 options were available
          option_method :like_text
          option_method :docs
          option_method :ids

          option_method :fields
          option_method :min_term_freq
          option_method :max_query_terms
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
