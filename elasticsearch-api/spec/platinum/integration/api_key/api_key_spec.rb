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
    ADMIN_CLIENT.security.put_role(
      name: 'admin_role',
      body: {
        cluster: ['manage_api_key'],
        indices: [
          {
            names: '*',
            privileges: ['all']
          }
        ],
        applications: [
          {
            application: 'myapp',
            privileges: ['*'],
            resources: ['*']
          }
        ]
      }
    )
    ADMIN_CLIENT.security.put_user(
      username: 'api_key_user',
      body: {
        password: 'test-password',
        roles: [ 'admin_role' ],
        full_name: 'API key user'
      }
    )
    ADMIN_CLIENT.security.put_privileges(
      body:
        {
          myapp: {
            read: {
              application: 'myapp',
              name: 'read',
              actions: [ 'data:read/*' ]
            },
            write: {
              application: 'myapp',
              name: 'write',
              actions: [ 'data:write/*' ]
            }
          }
        }
    )
  end

  after do
    ADMIN_CLIENT.security.delete_role(name: "admin_role", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "api_key_user", ignore: 404)
    ADMIN_CLIENT.security.delete_privileges(application: 'myapp', name: "read,write", ignore: 404)
  end

  let(:credentials) { Base64.strict_encode64("api_key_user:test-password") }
  let(:client) do
    Elasticsearch::Client.new(
      host: HOST,
      transport_options: TRANSPORT_OPTIONS.merge(headers: { Authorization: "Basic #{credentials}" })
    )
  end

  it 'creates api key' do
    response = client.security.create_api_key(
      body: {
        name: "my-api-key",
        expiration: "1d",
        role_descriptors: {
          'role-a' => {
            cluster: ["all"],
            index: [
              {
                names: ["index-a"],
                privileges: ["read"]
              }
            ]
          },
          'role-b' => {
            cluster: ["manage"],
            index: [
              {
                names: ["index-b"],
                privileges: ["all"]
              }
            ]
          }
        }
      }
    )
    expect(response['name']).to eq 'my-api-key'
    id = response['id']
    expect(id).not_to be nil
    expect(response['api_key']).not_to be nil
    expect(response['expiration']).not_to be nil
    credentials = Base64.strict_encode64("#{response['id']}:#{response['api_key']}")
    expect(credentials).to eq response['encoded']
    new_client = Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      transport_options: TRANSPORT_OPTIONS,
      api_key: credentials
    )
    response = new_client.security.authenticate
    expect(response['username']).to eq 'api_key_user'
    expect(response['roles'].length).to eq 0
    expect(response['authentication_realm']['name']).to eq '_es_api_key'
    expect(response['authentication_realm']['type']).to eq '_es_api_key'
    expect(response['api_key']['id']).to eq id
    expect(response['api_key']['name']).to eq 'my-api-key'
    response = ADMIN_CLIENT.security.clear_api_key_cache(ids: id)
    expect(response['_nodes']['failed']).to eq 0
  end

  context 'Test get api key' do
    let(:name) { 'my-api-key-2'}

    it 'gets api key' do
      response = ADMIN_CLIENT.security.create_api_key(
        body: { name: name, expiration: '1d' }
      )
      expect(response['name']).to eq name
      id = response['id']
      expect(id).not_to be nil
      expect(response['api_key']).not_to be nil
      expect(response['expiration']).not_to be nil

      response = ADMIN_CLIENT.security.get_api_key(id: id)
      expect(response['api_keys'].first['id']).to eq id
      expect(response['api_keys'].first['name']).to eq name
      expect(response['api_keys'].first['username']).to eq 'elastic'
      expect(response['api_keys'].first['invalidated']).to eq false
      expect(response['api_keys'].first['creation']).not_to be nil
      response = ADMIN_CLIENT.security.get_api_key(owner: true)
      expect(response['api_keys'].length).to be > 0
    end
  end
end
