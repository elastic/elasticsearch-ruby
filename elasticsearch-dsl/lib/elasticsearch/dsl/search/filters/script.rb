module Elasticsearch
  module DSL
    module Search
      module Filters

        # Script filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-script-filter.html
        #
        class Script
          include BaseComponent

          option_method :script
          option_method :params
        end

      end
    end
  end
end
