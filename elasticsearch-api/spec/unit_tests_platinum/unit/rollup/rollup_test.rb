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

require 'test_helper'

module Elasticsearch
  module Test
    class XPackRollupTest < Minitest::Test
      context "XPack Rollup: rollup an index" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal('POST', method)
            assert_equal('foo/_rollup/bar', url)
            assert_equal({}, params)
            assert_equal(body, {})
            true
          end.returns(FakeResponse.new)

          subject.rollup.rollup(body: {}, index: 'foo', rollup_index: 'bar')
        end

        should 'raise argument error without body' do
          assert_raises ArgumentError do
            subject.rollup.rollup(index: 'foo', rollup_index: 'bar')
          end
        end

        should 'raise argument error without index' do
          assert_raises ArgumentError do
            subject.rollup.rollup(body: {}, rollup_index: 'bar')
          end
        end

        should 'raise argument error without rollup_index' do
          assert_raises ArgumentError do
            subject.rollup.rollup(body: {}, index: 'foo')
          end
        end
      end
    end
  end
end
