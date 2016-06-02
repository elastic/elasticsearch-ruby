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
            last_index = @value.length == 0 ? 0 : -1
            @value[last_index] = @args if @args
          end

          @hash = @value.flatten
          @hash
        end

        def empty?
          @value.empty? && @args.empty?
        end
      end
    end
  end
end
