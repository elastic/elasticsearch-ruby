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

describe 'client#security#get_api_key' do

  let(:expected_args) do
    [
        'GET',
        '_security/api_key',
        params,
        nil,
        {},
        { endpoint: 'security.get_api_key' }
    ]
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.security.get_api_key).to be_a Elasticsearch::API::Response
  end

  context 'when params are specified' do

    let(:params) do
      { id: '1',
        username: 'user',
        name: 'my-api-key',
        realm_name: '_es_api_key' }
    end

    it 'performs the request' do
      expect(client_double.security.get_api_key(id: '1',
                                                   username: 'user',
                                                   name: 'my-api-key',
                                                   realm_name: '_es_api_key')).to be_a Elasticsearch::API::Response
    end
  end
end
