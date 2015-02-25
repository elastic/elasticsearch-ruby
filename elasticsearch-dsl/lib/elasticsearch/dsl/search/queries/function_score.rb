module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which allows to modify the score of documents matching the query,
        # either via built-in functions or a custom script
        #
        # @example Find documents with specific amenities, boosting documents within a certain
        #          price range and geogprahical location
        #
        #     search do
        #       query do
        #         function_score do
        #           filter do
        #             terms amenities: ['wifi', 'pets']
        #           end
        #           functions << { gauss: { price:    { origin: 100, scale: 200 } } }
        #           functions << { gauss: { location: { origin: '50.090223,14.399590', scale: '5km' } } }
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/guide/current/function-score-query.html
        #
        class FunctionScore
          include BaseComponent

          option_method :script_score
          option_method :boost
          option_method :max_boost
          option_method :score_mode
          option_method :boost_mode

          def initialize(*args, &block)
            super
            @functions = []
          end

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

          # DSL method for building the `functions` part of the query definition
          #
          # @return [Array]
          #
          def functions(value=nil)
            if value
              @functions = value
            else
              @functions
            end
          end

          # Set the `functions` part of the query definition
          #
          # @return [Array]
          #
          def functions=(value)
            @functions = value
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
            unless @functions.empty?
              hash[self.name].update(functions: @functions)
            end
            hash
          end
        end

      end
    end
  end
end
