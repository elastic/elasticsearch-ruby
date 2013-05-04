module Elasticsearch
  module Client
    module Transport
      module Connections

        class Collection
          include Enumerable

          DEFAULT_SELECTOR = Selector::RoundRobin

          attr_reader :connections, :selector

          def initialize(arguments={})
            selector_class = arguments[:selector_class] || DEFAULT_SELECTOR
            @connections   = arguments[:connections]    || []
            @selector      = arguments[:selector]       || selector_class.new(arguments)
          end

          def hosts
            connections.to_a.map { |c| c.host }
          end

          def get_connection(options={})
            selector.select(options)
          end

          def each(&block)
            connections.each(&block)
          end

          def slice(*args)
            connections.slice(*args)
          end
          alias :[] :slice

          def size
            connections.size
          end
        end

      end
    end
  end
end
