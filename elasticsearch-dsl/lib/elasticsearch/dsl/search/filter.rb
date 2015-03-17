module Elasticsearch
  module DSL
    module Search

      # Contains the classes for Elasticsearch filters
      #
      module Filters;end

      # Wraps the `filter` part of a search definition, aggregation, etc
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filters.html
      #
      class Filter
        def initialize(*args, &block)
          @block = block
        end

        # Looks up the corresponding class for a method being invoked, and initializes it
        #
        # @raise [NoMethodError] When the corresponding class cannot be found
        #
        def method_missing(name, *args, &block)
          klass = Utils.__camelize(name)
          if Filters.const_defined? klass
            @value = Filters.const_get(klass).new *args, &block
          else
            raise NoMethodError, "undefined method '#{name}' for #{self}"
          end
        end

        # Evaluates any block passed to the query
        #
        # @return [self]
        #
        def call
          @block.arity < 1 ? self.instance_eval(&@block) : @block.call(self) if @block
          self
        end

        # Converts the query definition to a Hash
        #
        # @return [Hash]
        #
        def to_hash(options={})
          call
          if @value
            @value.to_hash
          else
            {}
          end
        end
      end

    end
  end
end
