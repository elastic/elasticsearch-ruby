module Elasticsearch
  module DSL
    module Search

      # Module containing common functionality for DSL classes
      #
      module BaseCompoundFilterComponent
        include Enumerable

        def initialize(*args, &block)
          super
          @value = []
        end

        def self.included(base)
          base.__send__ :include, InstanceMethods
        end

        module InstanceMethods
          def each(&block)
            @value.each(&block)
          end

          def slice(*args)
            @value.slice(*args)
          end; alias :[] :slice

          def size
            @value.size
          end

          def <<(value)
            @value << value
          end

          def empty?
            @value.empty?
          end

          def to_hash(options={})
            if @value.empty?
              super
            else
              { name.to_sym => @value }
            end
          end
        end
      end
    end
  end
end
