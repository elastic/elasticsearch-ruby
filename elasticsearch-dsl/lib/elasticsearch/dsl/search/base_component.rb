module Elasticsearch
  module DSL
    module Search

      # Module containing common functionality for DSL classes
      #
      module BaseComponent
        def self.included(base)
          base.__send__ :extend,  ClassMethods
          base.__send__ :include, InstanceMethods

          base.instance_eval do
            #   Defines an "inner" method for DSL classes
            #
            #     @example Define a method `bar` for the MyQuery class which updates the query definition
            #
            #         class MyQuery
            #           include BaseComponent
            #
            #           option_method :bar
            #         end
            #
            #         q = MyQuery.new :foo do
            #           bar 'TEST'
            #         end
            #
            #         q.to_hash
            #         # => {:myquery=>{:foo=>{:bar=>"TEST"}}}
            #
            #     @example Define a method `bar` with custom logic for updating the Hash with query definition
            #
            #         class MyCustomQuery
            #           include BaseComponent
            #
            #           option_method :bar, lambda { |*args| @hash[self.name.to_sym][@args].update custom: args.pop }
            #         end
            #
            #         q = MyCustomQuery.new :foo do
            #           bar 'TEST'
            #         end
            #
            #         q.to_hash
            #       # => {:mycustomquery=>{:foo=>{:custom=>"TEST"}}}
            #
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

          # Get or set the name for the DSL class
          #
          # @example Set the index name for the `Article` model and re-evaluate it on each call
          #
          #     class MyQuery
          #       include BaseComponent
          #       name :my_special_query
          #     end
          #
          #     MyQuery.name
          #     # => :my_special_query
          #
          def name(value=nil)
            if value
              @name = value.to_sym
            else
              @name ||= self.to_s.split('::').last.downcase.to_sym
            end
          end

          # Set the name for the DSL class
          #
          def name=(value)
            @name = value.to_sym
          end
        end

        module InstanceMethods

          # Return the name for instance of the DSL class
          #
          def name
            self.class.name
          end

          # Convert the query definition to a Hash
          #
          # A default implementation, DSL classes can overload it.
          #
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
