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
      username: 'api_key_user',
      body: {
        password: 'x-pack-test-password',
        roles: [ 'user_role' ],
        full_name: 'API key user'
      }
    )
  end
  after do
    ADMIN_CLIENT.security.delete_role(name: "admin_role", ignore: 404)
    ADMIN_CLIENT.security.delete_role(name: "user_role", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "api_key_user", ignore: 404)
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
  let(:user_auth) do
    { Authorization: "Basic YXBpX2tleV9tYW5hZ2VyOngtcGFjay10ZXN0LXBhc3N3b3Jk" }
  end

  it 'queries api key with args' do
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
    id = response['id']
    api_key = response['api_key']
    expect(response['encoded']).to eq Base64.strict_encode64("#{id}:#{api_key}")

    client = client(user_auth)
    response = client.security.create_api_key(
      body: {
        name: 'user-api-key',
        expiration: '1d',
        metadata: {
          letter: 'a',
          number: 1
        }
      }
    )
    expect(response.status).to eq 200
    id = response['id']
    api_key = response['api_key']
    expect(response['encoded']).to eq Base64.strict_encode64("#{id}:#{api_key}")

    response = client.security.query_api_keys(
      body: {
        size: 0,
        aggs: {
          my_buckets: {
            composite: {
              sources: [{ key_name: { terms: { field: "name" } } } ]
            }
          }
        }
      }
    )
    expect(response.dig('aggregations', 'my_buckets', 'buckets').find { |a| a.dig('key', 'key_name') == 'manager-api-key'})
    expect(response.dig('aggregations', 'my_buckets', 'buckets').find { |a| a.dig('key', 'key_name') == 'user-api-key'})
  end
end
