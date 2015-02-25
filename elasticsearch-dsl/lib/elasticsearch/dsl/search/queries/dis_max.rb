module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which will score the documents based on the highest score of any individual specified query,
        # not by summing the scores (as eg. a `bool` query would)
        #
        # @example
        #
        #     search do
        #       query do
        #         dis_max do
        #           queries [
        #            { match: { title:   'albino' } },
        #            { match: { content: 'elephant' } }
        #           ]
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/_best_fields.html
        #
        class DisMax
          include BaseComponent

          option_method :queries
          option_method :boost
          option_method :tie_breaker
        end

      end
    end
  end
end
