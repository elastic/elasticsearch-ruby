module Elasticsearch
  module DSL
    module Search

      # Contains the classes for Elasticsearch queries
      #
      module Queries;end

      # Wraps the `query` part of a search definition
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl.html
      #
      class Query
        def initialize(*args, &block)
          @block = block
        end

        # Looks up the corresponding class for a method being invoked, and initializes it
        #
        # @raise [NoMethodError] When the corresponding class cannot be found
        #
        def method_missing(name, *args, &block)
          klass = name.capitalize
          if Queries.const_defined? klass
            @value = Queries.const_get(klass).new *args, &block
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
          @value ? @value.to_hash : {}
        end
      end
    end
  end
end
