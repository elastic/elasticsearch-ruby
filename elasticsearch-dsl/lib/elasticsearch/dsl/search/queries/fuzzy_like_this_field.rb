module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns documents which are similar to the specified text,
        # executed on a single field
        #
        # @example
        #
        #     search do
        #       query do
        #         fuzzy_like_this_field :content do
        #           like_text 'Eyjafjallajökull'
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-flt-field-query.html
        #
        class FuzzyLikeThisField
          include BaseComponent

          option_method :like_text
          option_method :fuzziness
          option_method :analyzer
          option_method :max_query_terms
          option_method :prefix_length
          option_method :boost
          option_method :ignore_tf
        end

      end
    end
  end
end
