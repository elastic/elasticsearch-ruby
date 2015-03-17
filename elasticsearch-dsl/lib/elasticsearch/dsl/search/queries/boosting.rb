module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which will decrease the score of documents matching the `negative` query
        #
        # @example
        #
        #     search do
        #       query do
        #         boosting do
        #           positive terms: { amenities: ['wifi', 'pets'] }
        #           negative terms: { amenities: ['pool'] }
        #           negative_boost 0.5
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-boosting-query.html
        #
        class Boosting
          include BaseComponent

          option_method :positive
          option_method :negative
          option_method :negative_boost
        end

      end
    end
  end
end
