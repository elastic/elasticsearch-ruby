module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which wraps a query so it can be used as a filter
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             query do
        #               query_string :title do
        #                 query 'Ruby OR Python'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-filter.html
        #
        class Query
          include BaseComponent

          def initialize(*args, &block)
            super
            if block
              @query = Elasticsearch::DSL::Search::Query.new(*args, &block)
              @block = nil
            end
          end

          # Converts the query definition to a Hash
          #
          # @return [Hash]
          #
          def to_hash
            hash = super
            if @query
              _query = @query.respond_to?(:to_hash) ? @query.to_hash : @query
              hash[self.name].update(_query)
            end
            hash
          end
        end

      end
    end
  end
end
