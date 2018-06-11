RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
JRUBY    = defined?(JRUBY_VERSION)

if RUBY_1_8 and not ENV['BUNDLE_GEMFILE']
  require 'rubygems'
  gem 'test-unit'
end

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

require 'ansi'
require 'test/unit' if RUBY_1_8
require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda/context'
require 'mocha/minitest'

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

Minitest::Reporters.use! FixedMinitestSpecReporter.new

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch/api'
RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  require 'elasticsearch/extensions/test/cluster'
  require 'elasticsearch/extensions/test/startup_shutdown'
  require 'elasticsearch/extensions/test/profiling' unless JRUBY
end

module Minitest
  module Assertions
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

module Elasticsearch
  module Test
    class UnitTest < Minitest::Unit::TestCase; end

    class FakeClient
      include Elasticsearch::API

      def perform_request(method, path, params, body, headers={"Content-Type" => "application/json"})
        puts "PERFORMING REQUEST:", "--> #{method.to_s.upcase} #{path} #{params} #{body} #{headers}"
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

    class NotFound < StandardError; end
  end
end
