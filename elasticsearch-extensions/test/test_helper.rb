require 'simplecov' and SimpleCov.start { add_filter "/test|test_/" } if ENV["COVERAGE"]

require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'ansi/code'
require 'turn' unless ENV["NOTURN"]

require 'elasticsearch/extensions'

module Elasticsearch
  module Test
    class IntegrationTestCase < ::Test::Unit::TestCase
    end
  end
end
