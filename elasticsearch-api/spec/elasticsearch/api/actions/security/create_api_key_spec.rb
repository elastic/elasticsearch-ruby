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

describe 'client#security#create_api_key' do

  let(:expected_args) do
    [
        'PUT',
        '_security/api_key',
        {},
        body,
        {},
        { endpoint: 'security.create_api_key' }
    ]
  end

  let(:body) do
    {
        "name": "my-api-key",
        "expiration": "1d",
        "role_descriptors": {
            "role-a": {
                "cluster": ["all"],
                "index": [
                    {
                        "names": ["index-a"],
                        "privileges": ["read"]
                    }
                ]
            },
            "role-b": {
                "cluster": ["manage"],
                "index": [
                    {
                        "names": ["index-b"],
                        "privileges": ["all"]
                    }
                ]
            }
        }
    }
  end

  it 'performs the request' do
    expect(client_double.security.create_api_key(body: body)).to be_a Elasticsearch::API::Response
  end

  context 'when params are specified' do

    let(:expected_args) do
      [
          'PUT',
          '_security/api_key',
          { refresh: 'wait_for' },
          body,
          {},
          { endpoint: 'security.create_api_key' }
      ]
    end

    it 'performs the request' do
      expect(client_double.security.create_api_key(body: body, refresh: 'wait_for')).to be_a Elasticsearch::API::Response
    end
  end
end
