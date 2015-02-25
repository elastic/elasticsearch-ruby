module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns children documents for parent documents matching a query
        #
        # @example Return comments for articles about Ruby
        #
        #     search do
        #       query do
        #         has_parent do
        #           type 'article'
        #           query do
        #             match title: 'Ruby'
        #           end
        #         end
        #       end
        #     end
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-has-parent-query.html
        #
        class HasParent
          include BaseComponent

          option_method :parent_type
          option_method :score_mode

          # DSL method for building the `query` part of the query definition
          #
          # @return [self]
          #
          def query(*args, &block)
            @query = block ? @query = Query.new(*args, &block) : args.first
            self
          end

          # Converts the query definition to a Hash
          #
          # @return [Hash]
          #
          def to_hash
            hash = super
            if @query
              _query = @query.respond_to?(:to_hash) ? @query.to_hash : @query
              hash[self.name].update(query: _query)
            end
            hash
          end
        end

      end
    end
  end
end
