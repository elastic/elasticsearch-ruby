module Elasticsearch
  module DSL
    module Search
      module Filters

        # Not filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-not-filter.html
        #
        class Not
          include BaseComponent
          include BaseCompoundFilterComponent
        end
      end
    end
  end
end
