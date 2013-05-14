module Elasticsearch
  module Client
    module Transport
      class Sniffer
        RE_URL  = /\/([^:]*):([0-9]+)\]/ # Use named groups on Ruby 1.9: /\/(?<host>[^:]*):(?<port>[0-9]+)\]/

        attr_reader   :transport
        attr_accessor :timeout

        def initialize(transport)
          @transport = transport
          @timeout   = transport.options[:sniffer_timeout] || 1
        end

        def hosts
          Timeout::timeout(timeout, SnifferTimeoutError) do
            nodes = transport.perform_request('GET', '_cluster/nodes').body
            hosts = nodes['nodes'].map do |id,info|
              if matches = info["#{transport.protocol}_address"].to_s.match(RE_URL)
                # TODO: Implement lightweight "indifferent access" here
                info.merge :host => matches[1], :port => matches[2], :id => id
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
