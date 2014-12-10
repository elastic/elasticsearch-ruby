module Elasticsearch
  module DSL
    module Search
      module Filters

        # Query filter
        #
        # @example
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
