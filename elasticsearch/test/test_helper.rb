RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

if RUBY_1_8
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
