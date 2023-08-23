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

  let(:client_username) { "query_api_keys_#{Time.new.to_i}"}
  let(:credentials) { Base64.strict_encode64("#{client_username}:test-password") }

  let(:client) do
    Elasticsearch::Client.new(
      host: HOST,
      transport_options: TRANSPORT_OPTIONS.merge(headers: { Authorization: "Basic #{credentials}" })
    )
  end

  it 'queries API keys' do
    key_name_1 = "query-key-1-#{Time.new.to_i}"
    response = client.security.create_api_key(
      body: {
        name: key_name_1,
        role_descriptors: {},
        expiration: "1d",
        metadata: { search: "this" }
      }
    )
    expect(response['name']).to eq key_name_1
    expect(response['api_key']).not_to be nil
    api_key_id_1 = response['id']

    key_name_2 = "query-key-2-#{Time.new.to_i}"
    response = client.security.create_api_key(
      body: {
        name: key_name_2,
        expiration: "2d",
        role_descriptors: { "role-a" => { "cluster": [ "monitor"] } },
        metadata: { search: false }
      }
    )
    expect(response['name']).to eq key_name_2
    expect(response['api_key']).not_to be nil
    api_key_id_2 = response['id']

    key_name_3 = "query-key-3#{Time.new.to_i}"
    response = client.security.create_api_key(
      body: {
        name: key_name_3,
        expiration: "3d",
      }
    )
    expect(response['name']).to eq key_name_3
    expect(response['api_key']).not_to be nil
    api_key_id_3 = response['id']

    response = client.security.authenticate
    owner_name = response['username']

    response = client.security.query_api_keys(
      body: {
        query: { wildcard: { name: key_name_1 }}
      }
    )
    expect(response['total']).to eq 1
    expect(response['count']).to eq 1
    expect(response['api_keys'].first['id']).to eq api_key_id_1

    response = client.security.query_api_keys(
      body: {
        query: { wildcard: { name: key_name_2 }}
      }
    )
    expect(response['total']).to eq 1
    expect(response['count']).to eq 1
    expect(response['api_keys'].first['id']).to eq api_key_id_2

    response = client.security.query_api_keys(
      body: {
        query: { wildcard: { name: key_name_3 }}
      }
    )
    expect(response['total']).to eq 1
    expect(response['count']).to eq 1
    expect(response['api_keys'].first['id']).to eq api_key_id_3
  end
end
