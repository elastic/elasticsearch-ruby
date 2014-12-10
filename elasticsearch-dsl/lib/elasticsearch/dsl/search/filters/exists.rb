module Elasticsearch
  module DSL
    module Search
      module Filters

        # Exists filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-exists-filter.html
        #
        class Exists
          include BaseComponent

          option_method :field
        end

      end
    end
  end
end
