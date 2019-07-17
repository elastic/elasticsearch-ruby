# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module Transport
    module Transport
      module Connections
        module Selector

          # @abstract Common functionality for connection selector implementations.
          #
          module Base
            attr_reader :connections

            # @option arguments [Connections::Collection] :connections Collection with connections.
            #
            def initialize(arguments={})
              @connections = arguments[:connections]
            end

            # @abstract Selector strategies implement this method to
            #           select and return a connection from the pool.
            #
            # @return [Connection]
            #
            def select(options={})
              raise NoMethodError, "Implement this method in the selector implementation."
            end
          end

          # "Random connection" selector strategy.
          #
          class Random
            include Base

            # Returns a random connection from the collection.
            #
            # @return [Connections::Connection]
            #
            def select(options={})
              connections.to_a.send( defined?(RUBY_VERSION) && RUBY_VERSION > '1.9' ? :sample : :choice)
            end
          end

          # "Round-robin" selector strategy (default).
          #
          class RoundRobin
            include Base

            # @option arguments [Connections::Collection] :connections Collection with connections.
            #
            def initialize(arguments = {})
              super
              @mutex = Mutex.new
              @current = nil
            end

            # Returns the next connection from the collection, rotating them in round-robin fashion.
            #
            # @return [Connections::Connection]
            #
            def select(options={})
              @mutex.synchronize do
                conns = connections
                if @current && (@current < conns.size-1)
                  @current += 1
                else
                  @current = 0
                end
                conns[@current]
              end
            end
          end
        end
      end
    end
  end
end
