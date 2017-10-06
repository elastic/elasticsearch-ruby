JRUBY = defined?(JRUBY_VERSION)

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'
  SimpleCov.start { add_filter "/test|test_" }
end

at_exit { Elasticsearch::Test::IntegrationTestCase.__run_at_exit_hooks }

require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'elasticsearch'
require 'elasticsearch/extensions/test/cluster'
require 'elasticsearch/extensions/test/startup_shutdown'

require 'elasticsearch/watcher'

module Elasticsearch
  module Test
    class IntegrationTestCase < ::Test::Unit::TestCase
      include Elasticsearch::Extensions::Test
      extend  StartupShutdown

      startup do
        Cluster.start(number_of_nodes: 1) if ENV['SERVER'] \
                                && ! Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 1)
      end

      shutdown do
        Cluster.stop if ENV['SERVER'] \
                     && started?      \
                     && Elasticsearch::Extensions::Test::Cluster.running?
      end

      def setup
        @port = (ENV['TEST_CLUSTER_PORT'] || 9250).to_i

        @logger =  Logger.new(STDERR)
        @logger.formatter = proc do |severity, datetime, progname, msg|
          color = case severity
            when /INFO/ then :green
            when /ERROR|WARN|FATAL/ then :red
            when /DEBUG/ then :cyan
            else :white
          end
          ANSI.ansi(severity[0] + ' ', color, :faint) + ANSI.ansi(msg, :white, :faint) + "\n"
        end

        @client = Elasticsearch::Client.new host: "localhost:#{@port}", logger: @logger
      end

      def teardown
        @client.indices.delete index: '_all'
      end
    end
  end
end

module Elasticsearch
  module Test
    class FakeClient
      include Elasticsearch::API::Watcher

      def perform_request(method, path, params, body)
        puts "PERFORMING REQUEST:", "--> #{method.to_s.upcase} #{path} #{params} #{body}"
        FakeResponse.new(200, 'FAKE', {})
      end
    end

    FakeResponse = Struct.new(:status, :body, :headers) do
      def status
        values[0] || 200
      end
      def body
        values[1] || '{}'
      end
      def headers
        values[2] || {}
      end
    end
  end
end
