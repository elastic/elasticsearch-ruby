module Elasticsearch
  module DSL
    module Search
      module Queries

        # Regexp query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html
        #
        class Regexp
          include BaseComponent

          option_method :value
          option_method :boost
          option_method :flags
        end

      end
    end
  end
end
