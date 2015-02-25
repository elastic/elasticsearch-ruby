module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns children documents for parent documents matching a query or a filter
        #
        # @example Return comments for articles about Ruby
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             has_parent do
        #               type 'article'
        #               query do
        #                 match title: 'Ruby'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-has-parent-filter.html
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
            @query = block ? @query = Elasticsearch::DSL::Search::Query.new(*args, &block) : args.first
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
