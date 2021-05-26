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
require 'uri'

ELASTICSEARCH_URL = ENV['TEST_ES_SERVER'] ||
                    "http://localhost:#{(ENV['PORT'] || 9200)}"
raise URI::InvalidURIError unless ELASTICSEARCH_URL =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

JRUBY = defined?(JRUBY_VERSION)

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start { add_filter "/test|test_" }
end

require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda/context'
require 'mocha/minitest'

require 'require-prof' if ENV['REQUIRE_PROF']
require 'elasticsearch'
RequireProf.print_timing_infos if ENV['REQUIRE_PROF']

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new(color: true)

module Minitest
  module Assertions
    def assert_nothing_raised(*)
      begin
        yield
      rescue RuntimeError => e
        raise MiniTest::Assertion, "Exception raised:\n<#{e.class}>", e.backtrace
      end
      true
    end

    def assert_not_nil(object, msg = nil)
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
    class IntegrationTestCase < ::Minitest::Test
    end
  end
end
