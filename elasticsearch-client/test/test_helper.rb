RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

require 'rubygems' if defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

require 'simplecov' and SimpleCov.start { add_filter "/test/" } if ENV["COVERAGE"]

require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["NOTURN"]

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch-client'

RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

class Test::Unit::TestCase
  def setup
  end

  def teardown
  end
end
