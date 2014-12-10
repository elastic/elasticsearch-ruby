module Elasticsearch
  module DSL
    module Search
      module Filters

        # Type filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-type-filter.html
        #
        class Type
          include BaseComponent

          option_method :value
        end

      end
    end
  end
end
