module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns documents matching a specified prefix
        #
        # @example
        #
        # search do
        #   query do
        #     prefix :title do
        #       value 'dis'
        #     end
        #   end
        # end
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
