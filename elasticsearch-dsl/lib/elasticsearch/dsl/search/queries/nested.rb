module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns the root documents for nested documents matching the specified query
        #
        # @example Return articles where John has commented
        #
        #     search do
        #       query do
        #         nested do
        #           path 'comments'
        #           query do
        #             match user: 'John'
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-nested-query.html
        #
        class Nested
          include BaseComponent

          option_method :path
          option_method :score_mode
          option_method :inner_hits

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
