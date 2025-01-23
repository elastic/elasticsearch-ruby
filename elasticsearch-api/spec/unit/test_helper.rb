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

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'pathname'
require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda/context'
require 'mocha/minitest'
require 'ansi'
require 'elasticsearch'
require 'elasticsearch/api'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new(print_failure_summary: true)

module Minitest
  class Test
    def assert_nothing_raised(*args)
      begin
        line = __LINE__
        yield
      rescue Exception => e
        raise MiniTest::Assertion, "Exception raised:\n<#{e.class}>", e.backtrace
      end
      true
    end
  end
end

module Elasticsearch
  module Test
    class FakeClient
      include Elasticsearch::API

      def perform_request(method, path, params, body)
        puts 'PERFORMING REQUEST:', "--> #{method.to_s.upcase} #{path} #{params} #{body}"
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
