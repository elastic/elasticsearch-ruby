module Elasticsearch
  module DSL
    module Search
      module Filters

        # Missing filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-missing-filter.html
        #
        class Missing
          include BaseComponent

          option_method :field
          option_method :existence
          option_method :null_value
        end

      end
    end
  end
end
