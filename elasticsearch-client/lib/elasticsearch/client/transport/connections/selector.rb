module Elasticsearch
  module Client
    module Transport
      module Connections
        module Selector

          module Base
            attr_reader :connections

            def initialize(arguments={})
              @connections = arguments[:connections]
            end

            def select(options={})
              raise NoMethodError, "Implement this method in the selector implementation."
            end
          end

          class Random
            include Base

            def select(options={})
              connections.to_a.send( defined?(RUBY_VERSION) && RUBY_VERSION > '1.9' ? :sample : :choice)
            end
          end

          class RoundRobin
            include Base

            def select(options={})
              # On Ruby 1.9, Array#rotate could be used instead
              @current = @current.nil? ? 0 : @current+1
              @current = 0 if @current >= connections.size
              connections[@current]
            end
          end

        end
      end
    end
  end
end
