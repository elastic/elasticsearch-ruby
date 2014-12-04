module Elasticsearch
  module DSL
    module Search
      module Queries

        # Fuzzy query
        #
        # @example
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
