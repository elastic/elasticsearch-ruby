# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.


ELASTICSEARCH_HOSTS = if hosts = ENV['TEST_ES_SERVER'] || ENV['ELASTICSEARCH_HOSTS']
                        hosts.split(',').map do |host|
                          /(http\:\/\/)?(\S+)/.match(host)[2]
                        end
                      end.freeze

TEST_HOST, TEST_PORT = ELASTICSEARCH_HOSTS.first.split(':') if ELASTICSEARCH_HOSTS

RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
JRUBY    = defined?(JRUBY_VERSION)

if RUBY_1_8 and not ENV['BUNDLE_GEMFILE']
  require 'rubygems'
  gem 'test-unit'
end

require 'rubygems' if RUBY_1_8

if ENV['COVERAGE'] && ENV['CI'].nil? && !RUBY_1_8
  require 'simplecov'
  SimpleCov.start { add_filter "/test|test_/" }
end

if ENV['CI'] && !RUBY_1_8
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start { add_filter "/test|test_" }
end

# Register `at_exit` handler for integration tests shutdown.
# MUST be called before requiring `test/unit`.
if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  at_exit { Elasticsearch::Test::IntegrationTestCase.__run_at_exit_hooks }
end

require 'test/unit' if RUBY_1_8
require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda/context'
require 'mocha/minitest'
require 'ansi/code'

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch-transport'
require 'logger'

require 'hashie'

RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  require 'elasticsearch/extensions/test/cluster'
  require 'elasticsearch/extensions/test/startup_shutdown'
  require 'elasticsearch/extensions/test/profiling' unless JRUBY
end

class FixedMinitestSpecReporter < Minitest::Reporters::SpecReporter
  def before_test(test)
    last_test = tests.last

    before_suite(test.class) unless last_test

    if last_test && last_test.klass.to_s != test.class.to_s
      after_suite(last_test.class) if last_test
      before_suite(test.class)
    end
  end
end

module Minitest
  class Test
    def assert_nothing_raised(*args)
      begin
        line = __LINE__
        yield
      rescue RuntimeError => e
        raise MiniTest::Assertion, "Exception raised:\n<#{e.class}>", e.backtrace
      end
      true
    end

    def assert_not_nil(object, msg=nil)
      msg = message(msg) { "<#{object.inspect}> expected to not be nil" }
      assert !object.nil?, msg
    end

    def assert_block(*msgs)
      assert yield, *msgs
    end

    alias :assert_raise :assert_raises
  end
end

Minitest::Reporters.use! FixedMinitestSpecReporter.new

module Elasticsearch
  module Test
    class IntegrationTestCase < Minitest::Test
      extend Elasticsearch::Extensions::Test::StartupShutdown

      shutdown { Elasticsearch::Extensions::Test::Cluster.stop if ENV['SERVER'] && started? && Elasticsearch::Extensions::Test::Cluster.running? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  end

  module Test
    class ProfilingTest < Minitest::Test
      extend Elasticsearch::Extensions::Test::StartupShutdown
      extend Elasticsearch::Extensions::Test::Profiling

      shutdown { Elasticsearch::Extensions::Test::Cluster.stop if ENV['SERVER'] && started? && Elasticsearch::Extensions::Test::Cluster.running? }
      context "IntegrationTest" do; should "noop on Ruby 1.8" do; end; end if RUBY_1_8
    end unless RUBY_1_8 || JRUBY
  end
end
