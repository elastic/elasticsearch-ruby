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

require 'elasticsearch/dsl'

module Elasticsearch
  module Test
    class IntegrationTestCase < ::Test::Unit::TestCase
      extend Elasticsearch::Extensions::Test::StartupShutdown

      shutdown { Elasticsearch::Extensions::Test::Cluster.stop if ENV['SERVER'] && started? && Elasticsearch::Extensions::Test::Cluster.running? }
    end
  end
end
