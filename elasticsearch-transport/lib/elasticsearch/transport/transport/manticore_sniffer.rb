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
          @stopping = false
          super
        end

        def sniff_every(interval_seconds, &block)
          logger.info("Will sniff every #{interval_seconds} seconds for new Elasticsearch hosts!")
          @state_mutex.synchronize do
            return if @sniffer_thread
            @sniffer_thread = Thread.new do
              last_sniff = Time.now
              until @state_mutex.synchronize { @stopping }
                sleep 1
                begin
                  if (Time.now - last_sniff) > interval_seconds
                    yield hosts if block_given?
                    last_sniff = Time.now
                  end
                rescue Exception => e
                  logger.warn("Error while sniffing Elasticsearch Nodes! [#{e.class.name}][#{e.message}][#{e.backtrace.to_a}]") if logger
                end
              end
            end
          end
        end

        def hosts
          nodes = transport.perform_request('GET', '_nodes/http', :timeout => timeout).body
          urls = hosts_from_nodes(nodes).map {|n| "#{transport.protocol}://#{n["http_address"]}"}
          puts "URLS ARE #{urls}"
          urls
        end

        def stop
          @state_mutex.synchronize do
            @stopping = true
            @sniffer_thread.join if @sniffer_thread
          end
        end
      end
    end
  end
end
