RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

require 'rubygems' if RUBY_1_8

require 'simplecov' and SimpleCov.start { add_filter "/test|test_/" } if ENV["COVERAGE"]

# Register `at_exit` handler for integration tests shutdown.
# MUST be called before requiring `test/unit`.
at_exit { Elasticsearch::Test::IntegrationTestCase.__run_at_exit_hooks }

require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'ansi/code'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["NOTURN"] || RUBY_1_8

require 'test_extensions'

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch-client'
require 'elasticsearch/client/extensions/test_cluster'
require 'logger'

RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

class Test::Unit::TestCase
  def setup
  end

  def teardown
  end
end

module Elasticsearch
  module Test
    class IntegrationTestCase < ::Test::Unit::TestCase
      extend IntegrationTestStartupShutdown

      shutdown { Elasticsearch::TestCluster.stop if ENV['SERVER'] && started? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end
  end

  module Test
    class ProfilingTest < ::Test::Unit::TestCase
      extend IntegrationTestStartupShutdown
      extend ProfilingTestSupport

      shutdown { Elasticsearch::TestCluster.stop if ENV['SERVER'] && started? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end
  end
end
