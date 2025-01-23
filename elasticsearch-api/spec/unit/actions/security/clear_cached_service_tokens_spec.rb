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

require 'spec_helper'

describe 'client#security#clear_cached_service_tokens' do
  let(:expected_args) do
    [
      'POST',
      '_security/service/foo/bar/credential/token/service_token/_clear_cache',
      {},
      nil,
      {},
      { defined_params: { name: 'service_token', namespace: 'foo', service: 'bar' },
        endpoint: 'security.clear_cached_service_tokens' }
    ]
  end

  it 'performs the request' do
    expect(client_double.security.clear_cached_service_tokens(
             namespace: 'foo', service: 'bar', name: 'service_token')
          ).to be_a Elasticsearch::API::Response
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :namespace argument' do
    expect {
      client.security.clear_cached_service_tokens(service: 'bar', name: 'service_token')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :service argument' do
    expect {
      client.security.clear_cached_service_tokens(namespace: 'foo', name: 'service_token')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :name argument' do
    expect {
      client.security.clear_cached_service_tokens(service: 'bar', namespace: 'foo')
    }.to raise_exception(ArgumentError)
  end
end
