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

describe 'Token API' do
  before do
    ADMIN_CLIENT.security.put_role(
      name: 'admin_role',
      body: { cluster: ['manage_security'] }
    )
    ADMIN_CLIENT.security.put_user(
      username: 'token_user',
      body: {
        password: 'x-pack-test-password',
        roles: [ 'admin_role' ],
        full_name: 'Token user'
      }
    )
  end

  after do
    ADMIN_CLIENT.security.delete_role(name: "admin_role", ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: "token_user", ignore: 404)
  end

  it 'invalidates user token' do
    response = ADMIN_CLIENT.security.get_token(
      body: { grant_type: "password", username: "token_user", password: "x-pack-test-password" }
    )

    expect(response.status).to eq 200
    expect(response['type']).to eq 'Bearer'
    expect(response['access_token']).not_to be_nil
    access_token = response['access_token']
    client = Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      transport_options: TRANSPORT_OPTIONS.merge(
        headers: { Authorization: "Bearer #{access_token}" }
      )
    )
    response = client.security.authenticate
    expect(response.status).to eq 200
    expect(response['username']).to eq 'token_user'
    expect(response['roles'].first).to eq 'admin_role'
    ADMIN_CLIENT.security.invalidate_token(
      body: { username: 'token_user' }
    )

    expect do
      client.security.authenticate
    end.to raise_error(Elastic::Transport::Transport::Errors::Unauthorized)
  end

  it 'invalidates realm token' do
    response = ADMIN_CLIENT.security.get_token(
      body: { grant_type: "password", username: "token_user", password: "x-pack-test-password" }
    )
    expect(response.status).to eq 200
    expect(response['type']).to eq 'Bearer'
    expect(response['access_token']).not_to be_nil
    access_token = response['access_token']
    client = Elasticsearch::Client.new(
      host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
      transport_options: TRANSPORT_OPTIONS.merge(
        headers: { Authorization: "Bearer #{access_token}" }
      )
    )
    response = client.security.authenticate
    expect(response.status).to eq 200
    expect(response['username']).to eq 'token_user'
    expect(response['roles'].first).to eq 'admin_role'
    response = ADMIN_CLIENT.security.invalidate_token(body: { realm_name: 'default_native' })
    expect(response.status).to eq 200

    expect do
      client.security.authenticate
    end.to raise_error(Elastic::Transport::Transport::Errors::Unauthorized)
  end
end
