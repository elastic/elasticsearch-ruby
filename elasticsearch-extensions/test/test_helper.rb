JRUBY    = defined?(JRUBY_VERSION)

if ENV['COVERAGE'] && ENV['CI'].nil? && !RUBY_1_8
  require 'simplecov'
  SimpleCov.start { add_filter "/test|test_" }
end

require 'minitest/autorun'
require 'shoulda-context'
require 'mocha/setup'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'ansi/code'
require 'logger'

require 'elasticsearch/extensions'
require 'elasticsearch/extensions/test/startup_shutdown'
require 'elasticsearch/extensions/test/cluster'

module Elasticsearch
  module Test
    module Assertions
      def assert_nothing_raised(*)
        yield
      end
    end

    class UnitTestCase < ::Minitest::Test
      include Assertions
      alias_method :assert_not_nil, :refute_nil
      alias_method :assert_raise, :assert_raises
    end

    class IntegrationTestCase < ::Minitest::Test
      include Assertions
      alias_method :assert_not_nil, :refute_nil
      alias_method :assert_raise, :assert_raises

      include Elasticsearch::Extensions::Test
      extend  StartupShutdown

      startup do
        Elasticsearch::Extensions::Test::Cluster.start(number_of_nodes: 2) if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 2)
      end

      shutdown do
        Elasticsearch::Extensions::Test::Cluster.stop(number_of_nodes: 2) if ENV['SERVER'] and Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 2)
      end
    end
  end
end
