module Elasticsearch
  module DSL
    module Search
      class Query
        def initialize(*args, &block)
          @block = block
        end

        def call
          @block.arity < 1 ? self.instance_eval(&@block) : @block.call(self) if @block
          self
        end

        def method_missing(name, *args, &block)
          klass = name.capitalize
          if Queries.const_defined? klass
            @value = Queries.const_get(klass).new *args, &block
          else
            raise NoMethodError, "undefined method '#{name}' for #{self}"
          end
        end

        def to_hash(options={})
          call
          @value ? @value.to_hash : {}
        end
      end
    end
  end
end
