RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

exit(0) if RUBY_1_8

if ENV['COVERAGE'] && ENV['CI'].nil?
  require 'simplecov'
  SimpleCov.start { add_filter "/test|test_/" }
end

if ENV['CI']
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start { add_filter "/test|test_|ansi" }
end

require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'ansi/code'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["NOTURN"] || RUBY_1_8

require 'elasticsearch/extensions'

module Elasticsearch
  module Test
    class IntegrationTestCase < ::Test::Unit::TestCase
    end
  end
end
