module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which uses a Levenshtein distance on string fields and plus-minus margin on numerical
        # fields to match documents
        #
        # @example
        #
        #     search do
        #       query do
        #         fuzzy :name do
        #           value 'Eyjafjallajökull'
        #         end
        #       end
        #     end
        #
        # @example
        #
        #     search do
        #       query do
        #         fuzzy :published_on do
        #           value '2014-01-01'
        #           fuzziness '7d'
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html
        #
        class Fuzzy
          include BaseComponent

          option_method :value
          option_method :boost
          option_method :fuzziness
          option_method :prefix_length
          option_method :max_expansions
        end

      end
    end
  end
end
