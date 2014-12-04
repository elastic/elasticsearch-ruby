module Elasticsearch
  module DSL
    module Search
      module Queries

        # DisMax query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/_best_fields.html
        #
        class DisMax
          include BaseComponent

          option_method :tie_breaker
          option_method :boost
          option_method :queries
        end

      end
    end
  end
end
