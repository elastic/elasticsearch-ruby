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

require_relative '../platinum_helper'

describe 'API keys' do
  before do
    ADMIN_CLIENT.security.put_role(
      name: 'admin_role',
      body: { cluster: ['manage_api_key'] }
    )
    ADMIN_CLIENT.security.put_role(
      name: 'user_role',
      body: {
        cluster: ['manage_own_api_key'],
      }
    )
    ADMIN_CLIENT.security.put_user(
      username: 'api_key_manager',
      body: {
        password: 'x-pack-test-password',
        roles: [ 'admin_role' ],
        full_name: 'API key manager'
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
    ADMIN_CLIENT.security.put_user(
      username: 'api_key_user_2',
      body: {
        password: 'x-pack-test-password',
        roles: [ 'user_role' ],
        full_name: 'API key user 2'
      }
    )
  end

  after do
    ADMIN_CLIENT.security.delete_role(name: "admin_role", ignore: 404)
    ADMIN_CLIENT.security.delete_role(name: "user_role", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "api_key_user_1", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "api_key_user_2", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "api_key_manager", ignore: 404)
  end

  def client(headers)
    Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      transport_options: TRANSPORT_OPTIONS.merge(headers: headers)
    )
  end

  let(:manager_auth) do
    { Authorization: "Basic YXBpX2tleV9tYW5hZ2VyOngtcGFjay10ZXN0LXBhc3N3b3Jk" }
  end
  let(:user1_auth) do
    { Authorization: "Basic YXBpX2tleV91c2VyXzE6eC1wYWNrLXRlc3QtcGFzc3dvcmQ=" }
  end
  let(:user2_auth) do
    { Authorization: "Basic YXBpX2tleV91c2VyXzI6eC1wYWNrLXRlc3QtcGFzc3dvcmQ=" }
  end

  it 'queries api key' do
    # api_key_manager authorization:
    client = client(manager_auth)
    response = client.security.create_api_key(
      body: {
        name: 'manager-api-key',
        expiration: '10d',
        metadata: {
          letter: 'a',
          number: 42
        }
      }
    )
    expect(response.status).to eq 200
    manager_key_id = response['id']

    # api_key_user1 authorization:
    client = client(user1_auth)
    response = client.security.create_api_key(
      body: {
        name: 'user1-api-key',
        expiration: '1d',
        metadata: {
          letter: 'a',
          number: 1
        }
      }
    )
    expect(response.status).to eq 200
    user1_key_id = response['id']

    # api_key_user2 authorization
    client = client(user2_auth)
    response = client.security.create_api_key(
      body: {
        name: 'user2-api-key',
        expiration: '1d',
        metadata: {
          letter: 'b',
          number: 42
        }
      }
    )
    expect(response.status).to eq 200
    user1_key_id = response['id']

    client = client(manager_auth)
    response = client.security.query_api_keys
    expect(response.status).to eq 200
    manager_total = response['total']
    expect(manager_total).to be >= 3

    client = client(user1_auth)
    response = client.security.query_api_keys
    expect(response.status).to eq 200
    user_1_total = response['total']
    expect(user_1_total).to be >= 1
    expect(user_1_total).to be < manager_total

    client = client(user2_auth)
    response = client.security.query_api_keys
    expect(response.status).to eq 200
    user_2_total = response['total']
    expect(user_2_total).to be >= 1
    expect(user_2_total).to be < manager_total
  end
end
