module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which wraps another query or filter and returns a constant score for matching documents
        #
        # @example
        #
        #     search do
        #       query do
        #         constant_score do
        #           query do
        #             match content: 'Twitter'
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/ignoring-tfidf.html
        #
        class ConstantScore
          include BaseComponent

          option_method :boost

          # DSL method for building the `query` part of the query definition
          #
          # @return [self]
          #
          def query(*args, &block)
            @query = block ? @query = Query.new(*args, &block) : args.first
            self
          end

          # DSL method for building the `filter` part of the query definition
          #
          # @return [self]
          #
          def filter(*args, &block)
            @filter = block ? Filter.new(*args, &block) : args.first
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
            if @filter
              _filter = @filter.respond_to?(:to_hash) ? @filter.to_hash : @filter
              hash[self.name].update(filter: _filter)
            end
            hash
          end
        end

      end
    end
  end
end
