module Elasticsearch
  module DSL
    module Search
      module Filters

        # Regexp filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-regexp-filter.html
        #
        class Regexp
          include BaseComponent

          option_method :value
          option_method :flags
        end

      end
    end
  end
end
