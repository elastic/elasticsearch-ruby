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

require 'base64'
require_relative '../platinum_helper'

describe 'API keys' do
  before do
    ADMIN_CLIENT.security.put_user(
      username: client_username,
      body: { password: 'test-password', roles: ['superuser'] }
    )
  end

  after do
    ADMIN_CLIENT.security.delete_user(username: client_username)
  end

  let(:client_username) { "superuser#{Time.now.to_i}"}

  let(:client) do
    Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      user: client_username,
      password: 'test-password',
      transport_options: TRANSPORT_OPTIONS
    )
  end

  it 'gets api key (with role descriptors + metadata)' do
    response = client.security.create_api_key(
      body: {
        name: "api-key-role",
        expiration: "1d",
        role_descriptors: {
          'role-a': {
                      cluster: ["all"],
                      index: [
                        {
                          names: ["index-a"],
                          privileges: ["read"]
                        }
                      ]
                    }
        },
        metadata: {
          string: "bean",
          number: 5,
          boolean: true
        }
      }
    )
    expect(response['name']).to eq 'api-key-role'
    expect(response['id']).not_to be nil
    expect(response['api_key']).not_to be nil
    expect(response['expiration']).not_to be nil
    api_key_id = response['id']
    api_key_name = response['name']
    credentials = response['encoded']

    response = client.security.authenticate
    owner_name = response['username']

    response = client.security.get_api_key(id: api_key_id)
    expect(response['api_keys'].first['id']).to eq api_key_id
    expect(response['api_keys'].first['name']).to eq api_key_name
    expect(response['api_keys'].first['username']).to eq owner_name
    expect(response['api_keys'].first['invalidated']).to eq false
    expect(response['api_keys'].first['creation']).not_to be nil
    expect(response['api_keys'].first['metadata']['string']).to eq 'bean'
    expect(response['api_keys'].first['metadata']['number']).to eq 5
    expect(response['api_keys'].first['metadata']['boolean']).to eq true
    expect(response['api_keys'].first['role_descriptors'])
      .to eq(
            {
              'role-a' => {
                'cluster' => ['all'],
                'indices' => [
                  {
                    'names' => ['index-a'],
                    'privileges' => ['read'],
                    'allow_restricted_indices' => false
                  }
                ],
                'applications' => [ ],
                'run_as' => [ ],
                'metadata' => { },
                'transient_metadata' => { 'enabled' => true }
              }
            }
          )

    response = client.security.get_api_key(owner: true)
    expect(response['api_keys'].length).to eq 1
    expect(response['api_keys'].first['id']).to eq api_key_id
    expect(response['api_keys'].first['name']).to eq api_key_name
    expect(response['api_keys'].first['username']).to eq owner_name
    expect(response['api_keys'].first['invalidated']).to eq false
    expect(response['api_keys'].first['creation']).not_to be nil

    client = Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      api_key: credentials,
      transport_options: TRANSPORT_OPTIONS
    )

    response = client.security.get_api_key(id: api_key_id)
    expect(response['api_keys'].length).to eq 1
    expect(response['api_keys'].first['id']).to eq api_key_id
    expect(response['api_keys'].first['name']).to eq api_key_name
    expect(response['api_keys'].first['username']).to eq owner_name
  end
end
