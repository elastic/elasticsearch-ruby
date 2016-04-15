require 'test_helper'

unless JRUBY
  version = ( defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'Ruby' ) + ' ' + RUBY_VERSION
  puts "SKIP: '#{File.basename(__FILE__)}' only supported on JRuby (you're running #{version})"
else
  class Elasticsearch::Transport::Transport::ManticoreSnifferTest < Test::Unit::TestCase
    require 'elasticsearch/transport/transport/http/manticore/manticore_sniffer'
    require 'manticore'

    class ManticoreDummyTransport < Elasticsearch::Transport::Transport::HTTP::Manticore
      def initialize(json=nil)
        @json ||= <<-JSON
        {
          "ok" : true,
          "cluster_name" : "elasticsearch_test",
          "nodes" : {
            "N1" : {
              "name" : "Node 1",
              "transport_address" : "inet[/192.168.1.23:9300]",
              "hostname" : "testhost1",
              "version" : "0.20.6",
              "http_address" : "inet[/192.168.1.23:9200]",
              "thrift_address" : "/192.168.1.23:9500",
              "memcached_address" : "inet[/192.168.1.23:11211]"
            }
          }
        }
        JSON
        @options = {}
      end

      def perform_request(method, path, options)
        Elasticsearch::Transport::Transport::Response.new 200, MultiJson.load(@json)
      end

      def protocol
        "http"
      end
    end

    context "Manticore Sniffer" do
      setup do
        @logger = Logger.new(STDERR)
        @logger.level = Logger::WARN
        @transport = ManticoreDummyTransport.new
        @transport.expects(:options).returns({:sniffer_timeout => 1}).at_least_once
        @sniffer   = Elasticsearch::Transport::Transport::HTTP::Manticore::ManticoreSniffer.new @transport, @logger
      end

      should "be initialized with a transport instance" do
        assert_equal @transport, @sniffer.transport
      end

      should "sniff every N seconds" do
        count = 0
        @sniffer.sniff_every(1) do |result|
          count += 1
        end
        sleep 5
        # Timing issues can make this inaccurate, 3 to 5 is close enough
        assert((3..5).include?(count), "Expcted 5 or 4 invocations. Got #{count}")
      end

    end

  end
end