module Elasticsearch
  module DSL
    module Search
      module Filters

        # Not filter
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-not-filter.html
        #
        class Not
          include BaseComponent

          # Looks up the corresponding class for a method being invoked, and initializes it
          #
          # @raise [NoMethodError] When the corresponding class cannot be found
          #
          def method_missing(name, *args, &block)
            klass = Utils.__camelize(name)
            if Filters.const_defined? klass
              @value = Filters.const_get(klass).new(*args, &block)
            else
              raise NoMethodError, "undefined method '#{name}' for #{self}"
            end
          end

          # Convert the component to a Hash
          #
          # A default implementation, DSL classes can overload it.
          #
          # @return [Hash]
          #
          def to_hash(options={})
            case
            when (! @value || @value.empty?) && ! @block
              @hash = super
            when @block
              call
              @hash = { name.to_sym => @value.to_hash }
            end
            @hash
          end
        end
      end
    end
  end
end
