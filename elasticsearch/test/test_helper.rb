RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

if RUBY_1_8 and not ENV['BUNDLE_GEMFILE']
  require 'rubygems'
  gem 'test-unit'
end

require 'simplecov' and SimpleCov.start { add_filter "/test|test_/" } if ENV["COVERAGE"]

require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["NOTURN"] || RUBY_1_8

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch'
RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

require '../elasticsearch-transport/lib/elasticsearch/transport/extensions/test_cluster'
require '../elasticsearch-transport/test/test_extensions'

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
