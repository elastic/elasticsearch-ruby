module Elasticsearch
  module DSL
    module Search
      module Filters

        # And filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-and-filter.html
        #
        class And
          include BaseComponent
          include BaseCompoundFilterComponent
        end
      end
    end
  end
end
