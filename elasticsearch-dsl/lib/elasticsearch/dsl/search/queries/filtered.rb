module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which allows to combine a query with a filter
        #
        # @note It's possible and common to define just the `filter` part of the search definition,
        #       for a structured search use case.
        #
        # @example Find documents about Twitter published last month
        #
        #     search do
        #       query do
        #         filtered do
        #           query do
        #             multi_match do
        #               query 'twitter'
        #               fields [ :title, :abstract, :content ]
        #             end
        #           end
        #           filter do
        #             range :published_on do
        #               gte 'now-1M/M'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filtered-query.html
        #
        class Filtered
          include BaseComponent

          option_method :strategy

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
