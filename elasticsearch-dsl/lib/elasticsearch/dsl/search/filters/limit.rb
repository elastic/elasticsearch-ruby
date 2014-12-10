module Elasticsearch
  module DSL
    module Search
      module Filters

        # Limit filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-limit-filter.html
        #
        class Limit
          include BaseComponent

          option_method :value
        end

      end
    end
  end
end
