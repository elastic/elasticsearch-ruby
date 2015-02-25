module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns parent documents for children documents matching a query or a filter
        #
        # @example Return articles where John has commented
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             has_child do
        #               type 'comment'
        #               query do
        #                 match author: 'John'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-has-child-filter.html
        #
        class HasChild
          include BaseComponent

          option_method :type
          option_method :min_children
          option_method :max_children

          # DSL method for building the `query` part of the query definition
          #
          # @return [self]
          #
          def query(*args, &block)
            @query = block ? Elasticsearch::DSL::Search::Query.new(*args, &block) : args.first
            self
          end

          # DSL method for building the `filter` part of the query definition
          #
          # @return [self]
          #
          def filter(*args, &block)
            @filter = block ? Elasticsearch::DSL::Search::Filter.new(*args, &block) : args.first
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
