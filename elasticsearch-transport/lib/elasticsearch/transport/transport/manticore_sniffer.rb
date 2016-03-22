module Elasticsearch
  module Transport
    module Transport

      # Handles node discovery ("sniffing")
      #
      class ManticoreSniffer < ::Elasticsearch::Transport::Transport::Sniffer
        ES1_RE_URL  = /\[([^\/]*)?\/?([^:]*):([0-9]+)\]/
        ES2_RE_URL  = /([^\/]*)?\/?([^:]*):([0-9]+)/

        attr_reader   :transport
        attr_accessor :timeout

        # @param transport [Object] A transport instance
        #
        def initialize(*args)
          @state_mutex = Mutex.new
          super
        end

        def sniff_every(interval_seconds, &block)
          @state_mutex.synchronize do
            return if @sniffer_thread
            @sniffer_thread = Thread.new do
              loop do
                sleep 1
                begin
                  yield hosts
                rescue StandardError => e

                end
              end
            end
          end
        end

        def hosts
          nodes = transport.perform_request('GET', '_nodes/http', :timeout => timeout).body
          hosts_from_nodes(nodes)
        end
      end
    end
  end
end
