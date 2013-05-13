module Elasticsearch
  module Client
    module Transport
      module Connections

        class Collection
          include Enumerable

          DEFAULT_SELECTOR = Selector::RoundRobin

          attr_reader :selector

          def initialize(arguments={})
            selector_class = arguments[:selector_class] || DEFAULT_SELECTOR
            @connections   = arguments[:connections]    || []
            @selector      = arguments[:selector]       || selector_class.new(arguments)
          end

          def hosts
            @connections.to_a.map { |c| c.host }
          end

          def connections
            @connections.reject { |c| c.dead? }
          end
          alias :alive :connections

          def dead
            @connections.select { |c| c.dead? }
          end

          def all
            @connections
          end

          def get_connection(options={})
            if connections.empty? && dead_connection = dead.sort { |a,b| a.failures <=> b.failures }.first
              dead_connection.alive!
            end
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
