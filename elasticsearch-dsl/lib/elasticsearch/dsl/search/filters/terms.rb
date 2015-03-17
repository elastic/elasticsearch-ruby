module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents matching any term from the specified list of terms
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             terms tags: ['ruby', 'development']
        #           end
        #         end
        #       end
        #     end
        #
        # @note The specified terms are *not analyzed* (lowercased, stemmed, etc),
        #       so they must match the indexed terms.
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-terms-filter.html
        #
        class Terms
          include BaseComponent
        end

      end
    end
  end
end
