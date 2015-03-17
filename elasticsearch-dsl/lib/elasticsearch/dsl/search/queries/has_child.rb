module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns parent documents for children documents matching a query
        #
        # @example Return articles where John has commented
        #
        #     search do
        #       query do
        #         has_child do
        #           type 'comment'
        #           query do
        #             match author: 'John'
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-has-child-query.html
        #
        class HasChild
          include BaseComponent

          option_method :type
          option_method :score_mode
          option_method :min_children
          option_method :max_children

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
