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

describe 'API keys API' do
  before do
    ADMIN_CLIENT.security.put_role(
      name: 'user_role',
      body: {
        cluster: ['manage_own_api_key'],
        indices: [
          {
            names: '*',
            privileges: ['all']
          }
        ]
      }
    )
    ADMIN_CLIENT.security.put_user(
      username: 'api_key_user_1',
      body: {
        password: 'x-pack-test-password',
        roles: [ 'user_role' ],
        full_name: 'API key user 1'
      }
    )
  end

  after do
    ADMIN_CLIENT.security.delete_role(name: "user_role", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "api_key_user_1", ignore: 404)
  end

  let(:client) do
    Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      transport_options: TRANSPORT_OPTIONS.merge(
        headers: { Authorization: "Basic YXBpX2tleV91c2VyXzE6eC1wYWNrLXRlc3QtcGFzc3dvcmQ=" }
      )
    )
  end

  it 'updates api key' do
    response = client.security.create_api_key(
      body: {
        name: 'user1-api-key',
        role_descriptors: {
          "role-a" => {
            cluster: ["none"],
            index: [
              {
                names: ["index-a"],
                privileges: ["read"]
              }
            ]
          }
        }
      }
    )
    expect(response.status).to eq 200
    expect(response['name']).to eq 'user1-api-key'
    id = response['id']
    expect(id).not_to be nil
    expect(response['api_key']).not_to be nil
    credentials = Base64.strict_encode64("#{response['id']}:#{response['api_key']}")
    expect(credentials).to eq response['encoded']

    new_client = Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      transport_options: TRANSPORT_OPTIONS,
      api_key: credentials
    )
    privileges_body = {
      cluster: ['manage_own_api_key'],
      index: [
        {
          names: ['index-a'],
          privileges: ['write']
        },
        {
          names: ['index-b'],
          privileges: ['read']
        }
      ]
    }
    response = new_client.security.has_privileges(body: privileges_body)
    expect(response['has_all_requested']).to eq false

    response = client.security.update_api_key(
      id: id,
      body: {
        role_descriptors: {
          "role-a" => {
            cluster: ["all"],
            index: [
              {
                names: ["index-a"],
                privileges: ["write"]
              },
              {
                names: ["index-b"],
                privileges: ["read"]
              }
            ]
          }
        },
        metadata: {
          letter: "a",
          number: 42
        }
      }
    )
    expect(response['updated']).to eq true

    response = new_client.security.has_privileges(user: nil, body: privileges_body)
    expect(response['has_all_requested']).to eq true
  end
end
