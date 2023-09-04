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

describe 'client#security#get_service_credentials' do
  let(:expected_args) do
    [
      'GET',
      '_security/service/foo/bar/credential',
      {},
      nil,
      {},
      { defined_params: { namespace: 'foo', service: 'bar' },
        endpoint: 'security.get_service_credentials' }
    ]
  end

  it 'performs the request' do
    expect(
      client_double.security.get_service_credentials(namespace: 'foo', service: 'bar')
    ).to be_a Elasticsearch::API::Response
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :namespace argument' do
    expect {
      client.security.get_service_credentials(service: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :service argument' do
    expect {
      client.security.get_service_credentials(namespace: 'foo')
    }.to raise_exception(ArgumentError)
  end

end
