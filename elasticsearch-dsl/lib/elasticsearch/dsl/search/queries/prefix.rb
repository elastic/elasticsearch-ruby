module Elasticsearch
  module DSL
    module Search
      module Queries

        # Prefix query
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-prefix-query.html
        #
        class Prefix
          include BaseComponent

          option_method :value
          option_method :boost
        end

      end
    end
  end
end
