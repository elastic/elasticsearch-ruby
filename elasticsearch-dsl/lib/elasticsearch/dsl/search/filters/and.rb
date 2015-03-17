module Elasticsearch
  module DSL
    module Search
      module Filters

        # A compound filter which matches documents by an intersection of individual filters.
        #
        # @note Since `and` is a keyword in Ruby, use the `_and` method in DSL definitions
        #
        # @example Pass the filters as a Hash
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             _and filters: [ {term: { color: 'red' }}, {term: { size:  'xxl' }} ]
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
        #             _and do
        #               term color: 'red'
        #               term size:  'xxl'
        #             end
        #           end
        #         end
        #       end
        #     end
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
