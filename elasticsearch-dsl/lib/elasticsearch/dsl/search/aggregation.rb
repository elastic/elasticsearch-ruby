module Elasticsearch
  module DSL
    module Search

      # Contains the classes for Elasticsearch aggregations
      #
      module Aggregations;end

      class AggregationsCollection < Hash
        def to_hash
          @hash ||= Hash[map { |k,v| [k, v.to_hash] }]
        end
      end

      # Wraps the `aggregations` part of a search definition
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations.html
      #
      class Aggregation
        def initialize(*args, &block)
          @block = block
        end

        # Looks up the corresponding class for a method being invoked, and initializes it
        #
        # @raise [NoMethodError] When the corresponding class cannot be found
        #
        def method_missing(name, *args, &block)
          klass = Utils.__camelize(name)
          if Aggregations.const_defined? klass
            @value = Aggregations.const_get(klass).new *args, &block
          else
            raise NoMethodError, "undefined method '#{name}' for #{self}"
          end
        end

        # Defines an aggregation nested in another one
        #
        def aggregation(*args, &block)
          call
          @value.__send__ :aggregation, *args, &block
        end

        # Returns the aggregations
        #
        def aggregations
          call
          @value.__send__ :aggregations
        end

        # Evaluates the block passed to initializer, ensuring it is called just once
        #
        # @return [self]
        #
        # @api private
        #
        def call
          @block.arity < 1 ? self.instance_eval(&@block) : @block.call(self) if @block && ! @_block_called
          @_block_called = true
          self
        end

        # Converts the object to a Hash
        #
        # @return [Hash]
        #
        def to_hash(options={})
          call

          if @value
            case
              when @value.respond_to?(:to_hash)
                @value.to_hash
              else
                @value
            end
          else
            {}
          end
        end
      end

    end
  end
end
