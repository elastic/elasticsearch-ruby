module Elasticsearch
  module DSL
    module Search
      module Filters

        # A compound filter which matches documents by a union of individual filters.
        #
        # @note Since `or` is a keyword in Ruby, use the `_or` method in DSL definitions
        #
        # @example Pass the filters as a Hash
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             _or filters: [ {term: { color: 'red' }}, {term: { size:  'xxl' }} ]
        #           end
        #         end
        #       end
        #     end
        #
        # @example Define the filters with a block
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             _or do
        #               term color: 'red'
        #               term size:  'xxl'
        #             end
        #           end
        #         end
        #       end
        #     end
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
