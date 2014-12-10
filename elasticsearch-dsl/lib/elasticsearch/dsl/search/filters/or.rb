module Elasticsearch
  module DSL
    module Search
      module Filters

        # Or filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-or-filter.html
        #
        class Or
          include BaseComponent
          include BaseCompoundFilterComponent
        end
      end
    end
  end
end
