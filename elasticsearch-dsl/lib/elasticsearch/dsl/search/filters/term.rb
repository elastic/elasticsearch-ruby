module Elasticsearch
  module DSL
    module Search
      module Filters

        # Term filter
        #
        # @example
        #
        #     filter do
        #       term message: 'test'
        #     end
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-filter.html
        #
        class Term
          include BaseComponent
        end

      end
    end
  end
end
