module Elasticsearch
  module DSL
    module Search
      module BaseComponent

        def self.included(base)
          base.__send__ :extend,  ClassMethods
          base.__send__ :include, InstanceMethods

          base.instance_eval do
            def option_method(name, block=nil)
              if block
                self.__send__ :define_method, name, &block
              else
                self.__send__ :define_method, name do |*args|
                  @hash[self.name.to_sym] = { @args => {} } unless @hash[self.name.to_sym][@args]
                  @hash[self.name.to_sym][@args].update name.to_sym => args.pop
                end
              end
            end
          end
        end

        def initialize(*args, &block)
          @hash  = { name => {} }
          @args  = args.pop
          @block = block
        end

        module ClassMethods
          def name(value=nil)
            if value
              @name = value.to_sym
            else
              @name ||= self.to_s.split('::').last.downcase.to_sym
            end
          end

          def name=(value)
            @name = value.to_sym
          end
        end

        module InstanceMethods
          def name
            self.class.name
          end

          def to_hash(options={})
            if @block
              @hash = { name => { @args => {} } }
              @block.arity < 1 ? self.instance_eval(&@block) : @block.call(self)
            else
              @hash[self.name.to_sym] && @hash[self.name.to_sym][@args] ? @hash : @hash = { name => @args }
            end
            @hash
          end
        end
      end
    end
  end
end
