module Elasticsearch
  module Transport
    module Transport

      # Handles node discovery ("sniffing")
      #
      class Sniffer
        ES1_RE_URL  = /\[([^\/]*)?\/?([^:]*):([0-9]+)\]/
        ES2_RE_URL  = /([^\/]*)?\/?([^:]*):([0-9]+)/

        attr_reader   :transport
        attr_accessor :timeout

        # @param transport [Object] A transport instance
        #
        def initialize(transport)
          @transport = transport
          @timeout   = transport.options[:sniffer_timeout] || 1
        end

        # Retrieves the node list from the Elasticsearch's
        # [_Nodes Info API_](http://www.elasticsearch.org/guide/reference/api/admin-cluster-nodes-info/)
        # and returns a normalized Array of information suitable for passing to transport.
        #
        # Shuffles the collection before returning it when the `randomize_hosts` option is set for transport.
        #
        # @return [Array<Hash>]
        # @raise  [SnifferTimeoutError]
        #
        def hosts
          Timeout::timeout(timeout, SnifferTimeoutError) do
            nodes = transport.perform_request('GET', '_nodes/http').body
            hosts = nodes['nodes'].map do |id,info|
              addr_str = info["#{transport.protocol}_address"].to_s
              matches = addr_str.match(ES1_RE_URL) || addr_str.match(ES2_RE_URL)
              if matches
                host = matches[1].empty? ? matches[2] : matches[1]
                port = matches[3]
                info.merge :host => host, :port => port, :id => id
              end
            end.compact

            hosts.shuffle! if transport.options[:randomize_hosts]
            hosts
          end
        end
      end
    end
  end
end
