module Elasticsearch
  module DSL
    module Search

      # Wraps the `sort` part of a search definition
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-request-sort.html
      #
      class Sort
        include BaseComponent

        def initialize(*args, &block)
          @value ||= []
          super
        end

        # DSL method to specify sorting item
        #
        # @example
        #
        #     search do
        #       sort do
        #         by :category
        #         by :clicks, order: 'desc'
        #       end
        #     end
        #
        def by(name, direction=nil)
          @value << ( direction ? { name => direction } : name )
          self
        end

        # Convert the definition to a Hash
        #
        # @return [Hash]
        #
        def to_hash
          if @block
            call unless @block_called
            @block_called = true
          else
            @value << @args if @args && !@args.empty? && ! @value.include?(@args)
          end

          @hash = @value.flatten
          @hash
        end

        # Return whether the definition is empty
        #
        # @return [Boolean]
        #
        def empty?
          to_hash.empty?
        end
      end
    end
  end
end
