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
              option_methods << name
              if block
                self.__send__ :define_method, name, &block
              else
                self.__send__ :define_method, name do |*args|
                  # 1. Component has empty @args (ie. no user supplied name or @hash value)
                  if @args && @args.respond_to?(:to_hash) && @args.empty?
                    @hash[self.name.to_sym].update name.to_sym => args.first
                  # 2. Component user-supplied name or @hash value passed in @args
                  else
                    @hash[self.name.to_sym] = { @args => {} } unless @hash[self.name.to_sym][@args]
                    @hash[self.name.to_sym][@args].update name.to_sym => args.first
                  end
                end
              end
            end
          end
        end

        def initialize(*args, &block)
          @hash    = { name => {} }
          @args    = args.first || {}
          @options = args.size > 1 ? args.last : {}
          @block   = block
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
              @name ||= begin
                value = self.to_s.split('::').last
                value.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
                value.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
                value.tr!("-", "_")
                value.downcase!
                value.to_sym
              end
            end
          end

          # Set the name for the DSL class
          #
          def name=(value)
            @name = value.to_sym
          end

          def option_methods
            @option_methods ||= []
          end
        end

        module InstanceMethods

          # Return the name for instance of the DSL class
          #
          # @return [String]
          #
          def name
            self.class.name
          end

          # Evaluates any block passed to the query
          #
          # @return [self]
          #
          def call
            @block.arity < 1 ? self.instance_eval(&@block) : @block.call(self) if @block
            self
          end

          # Return true when the component definition is empty
          #
          def empty?
            to_hash[name].respond_to?(:empty?) && to_hash[name].empty?
          end

          # Convert the query definition to a Hash
          #
          # A default implementation, DSL classes can overload it.
          #
          # @return [Hash]
          #
          def to_hash(options={})
            case
              # 1. Create hash from the block
              when @block
                @hash = (@args && ! @args.empty?) ? { name => { @args => {} } } : { name => {} }
                call
                @hash[self.name.to_sym].update @options unless @options.empty?
                @hash
              # 2. Hash created with option methods
              when @hash[self.name.to_sym] && ! @args.is_a?(Hash) && @hash[self.name.to_sym][@args]
                @hash[self.name.to_sym].update @options unless @options.empty?
                @hash
              # 3. Hash passsed as @args
              when @hash[self.name.to_sym] && @args.respond_to?(:to_hash) && ! @args.empty?
                { name => @args.to_hash }
              # 4. Hash already built
              else
                @hash
            end
          end
        end
      end
    end
  end
end
