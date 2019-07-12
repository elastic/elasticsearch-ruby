# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search

      # Module containing common functionality for aggregation DSL classes
      #
      module BaseAggregationComponent

        def self.included(base)
          base.__send__ :include, BaseComponent
          base.__send__ :include, InstanceMethods
        end

        module InstanceMethods

          attr_reader :aggregations

          # Looks up the corresponding class for a method being invoked, and initializes it
          #
          # @raise [NoMethodError] When the corresponding class cannot be found
          #
          def method_missing(name, *args, &block)
            klass = Utils.__camelize(name)
            if Aggregations.const_defined? klass
              @value = Aggregations.const_get(klass).new *args, &block
            elsif @block
              @block.binding.eval('self').send(name, *args, &block)
            else
              super
            end
          end

          # Adds a nested aggregation into the aggregation definition
          #
          # @return [self]
          #
          def aggregation(*args, &block)
            @aggregations ||= AggregationsCollection.new
            @aggregations.update args.first => Aggregation.new(*args, &block)
            self
          end

          # Convert the aggregations to a Hash
          #
          # A default implementation, DSL classes can overload it.
          #
          # @return [Hash]
          #
          def to_hash(options={})
            call

            @hash = { name => @args } unless @hash && @hash[name] && ! @hash[name].empty?

            if @aggregations
              @hash[:aggregations] = @aggregations.to_hash
            end
            @hash
          end
        end

      end

    end
  end
end

