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
    class XPackSecurityGrantApiKey < Minitest::Test
      context "XPack Security: Grant API Key" do
        subject { FakeClient.new }
        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal('POST', method)
            assert_equal('_security/api_key/grant', url)
            assert_equal(Hash.new, params)
            assert_equal(body, {access_token: 'access_token', api_key: 'api_key', grant_type: 'access_token'})
            true
          end.returns(FakeResponse.new)

          subject.security.grant_api_key(
            body: {access_token: 'access_token', api_key: 'api_key', grant_type: 'access_token'}
          )
        end
      end
    end
  end
end
