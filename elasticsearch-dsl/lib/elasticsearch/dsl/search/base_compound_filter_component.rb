# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module DSL
    module Search

      # Module containing common functionality for a "compound" (wrapping) filters, such as `and`, `or`, `not`
      #
      module BaseCompoundFilterComponent
        include Enumerable

        def initialize(*args, &block)
          super
          @value = []
        end

        def self.included(base)
          base.__send__ :include, InstanceMethods
          base.__send__ :include, EnumerableMethods
          base.__send__ :include, MethodDelegation
        end

        # Common functionality for the compound filter components
        #
        module InstanceMethods
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

          # Convert the component to a Hash
          #
          # A default implementation, DSL classes can overload it.
          #
          # @return [Hash]
          #
          def to_hash(options={})
            case
            when @value.empty? && ! @block
              @hash = super
            when @block
              call
              @hash = { name.to_sym => @value.map { |i| i.to_hash } }
            else
              @hash = { name.to_sym => @value }
            end
            @hash
          end
        end

        # Implements the {Enumerable} methods
        #
        module EnumerableMethods
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
        end

        module MethodDelegation
          # Looks up the corresponding class for a method being invoked, and initializes it
          #
          # @raise [NoMethodError] When the corresponding class cannot be found
          #
          def method_missing(name, *args, &block)
            klass = Utils.__camelize(name)
            if Filters.const_defined? klass
              @value << Filters.const_get(klass).new(*args, &block)
            elsif @block
              @block.binding.eval('self').send(name, *args, &block)
            else
              super
            end
          end
        end
      end
    end
  end
end
