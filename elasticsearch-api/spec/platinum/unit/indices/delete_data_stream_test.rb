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
    class XPackIndicesDeleteDataStreamTest < Minitest::Test
      subject { FakeClient.new }

      context 'XPack: Delete Data Stream' do
        should 'perform correct request' do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal('DELETE', method)
            assert_equal('_data_stream/foo', url)
            assert_equal({}, params)
            assert_nil(body)
          end.returns(FakeResponse.new)

          subject.indices.delete_data_stream(name: 'foo')
        end
      end


      should 'raise argument error without name' do
        assert_raises ArgumentError do
          subject.indices.create_data_stream
        end
      end
    end
  end
end
