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

describe 'API keys API invalidation' do
  before do
    ADMIN_CLIENT.security.put_role(
      name: 'admin_role',
      body: {
        cluster: ['manage_api_key']
      }
    )
    ADMIN_CLIENT.security.put_role(
      name: 'user_role',
      body: {
        cluster: ['manage_own_api_key']
      }
    )
    ADMIN_CLIENT.security.put_user(
      username: 'api_key_manager',
      body: {
        password: 'changeme',
        roles: [ 'admin_role' ],
        full_name: 'API key manager'
      }
    )
    ADMIN_CLIENT.security.put_user(
      username: 'api_key_test_user1',
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
    ADMIN_CLIENT.security.delete_user(username: "api_key_user1", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "api_key_manager", ignore: 404)
  end

  let(:credentials) { Base64.strict_encode64("api_key_manager:changeme") }

  let(:client) do
    Elasticsearch::Client.new(
      host: HOST,
      transport_options: TRANSPORT_OPTIONS.merge(headers: { Authorization: "Basic #{credentials}" })
    )
  end

  it 'invalidates by realm name' do
    response = client.security.create_api_key(
      body: {
        name: "manager-api-key",
        expiration: "1d",
        role_descriptors: {}
      }
    )
    expect(response['name']).to eq 'manager-api-key'
    id = response['id']
    expect(id).not_to be nil
    expect(response['api_key']).not_to be nil
    expect(response['expiration']).not_to be nil

    user_credentials = Base64.strict_encode64('api_key_test_user1:x-pack-test-password')
    user_client = Elasticsearch::Client.new(
      host: HOST,
      transport_options: TRANSPORT_OPTIONS.merge(headers: { Authentication: "Basic #{user_credentials}" })
    )
    response = user_client.security.create_api_key(
      body: {
        name: "user1-api-key",
        expiration: "1d",
        role_descriptors: {}
      }
    )
    expect(response['name']).to eq 'user1-api-key'
    id = response['id']
    expect(id).not_to be nil
    expect(response['api_key']).not_to be nil
    expect(response['expiration']).not_to be nil

    response = client.security.invalidate_api_key(body: { realm_name: 'default_native'})
    expect(response['invalidated_api_keys'].count).to be >= 2
    expect(response['error_count']).to eq 0
  end
end
