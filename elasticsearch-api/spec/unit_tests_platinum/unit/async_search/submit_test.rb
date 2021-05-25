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
    class XPackAsyncSearchSubmit < Minitest::Test
      subject { FakeClient.new }

      context 'XPack: Async Search Submit' do
        should 'perform correct request' do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal('POST', method)
            assert_equal('_async_search', url)
            assert_equal({}, params)
            assert_nil(body)
          end.returns(FakeResponse.new)

          subject.async_search.submit
        end

        should 'perform correct request with index' do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal('POST', method)
            assert_equal('foo/_async_search', url)
            assert_equal({}, params)
            assert_nil(body)
          end.returns(FakeResponse.new)

          subject.async_search.submit(index: 'foo')
        end
      end
    end
  end
end
