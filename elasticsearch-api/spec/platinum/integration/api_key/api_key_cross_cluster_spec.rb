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
  let(:user) { 'admin_user' }
  let(:password) { 'x-pack-test-password' }
  before do
    ADMIN_CLIENT.security.put_role(
      name: 'admin_role',
      body: { cluster: ['manage_security'] }
    )
    ADMIN_CLIENT.security.put_user(
      username: user,
      body: {
        password: password,
        roles: ['admin_role'],
        full_name: 'Admin user'
      }
    )
  end

  after do
    ADMIN_CLIENT.security.delete_role(name: 'admin_role', ignore: 404)
    ADMIN_CLIENT.security.delete_user(username: user, ignore: 404)
  end

  describe 'Cross Cluster API Key' do
    it 'updates api key' do
      response = ADMIN_CLIENT.security.create_cross_cluster_api_key(
        body: {
          name: 'my-cc-api-key',
          expiration: '1d',
          access: {
            search: [
              { names: ['logs*'] }
            ],
            replication: [
              {
                names: ['archive'],
                allow_restricted_indices: false
              }
            ]
          },
          metadata: {
            answer: 42,
            tag: 'dev'
          }
        }
      )
      expect(response.status).to eq 200
      expect(response['name']).to eq 'my-cc-api-key'
      id = response['id']
      expect(id).not_to be nil
      expect(response['api_key']).not_to be nil
      expect(response['expiration']).not_to be nil
      credentials = Base64.strict_encode64("#{response['id']}:#{response['api_key']}")
      expect(credentials).to eq response['encoded']

      new_client = Elasticsearch::Client.new(
        host: "https://#{HOST_URI.host}:#{HOST_URI.port}",
        transport_options: TRANSPORT_OPTIONS
      )
      expect do
        new_client.security.authenticate(headers: { authorization: "ApiKey #{credentials}" })
      end.to raise_error(Elastic::Transport::Transport::Errors::Unauthorized)

      response = ADMIN_CLIENT.security.get_api_key(id: id, with_limited_by: true)
      expect(response.status).to eq 200
      api_key = response['api_keys'].first
      expect(api_key['name']) == 'my-cc-api-key'
      expect(api_key['type']) == 'cross_cluster'
      expect(api_key['invalidated']).to be false
      expect(api_key['metadata']).to eq({'answer' => 42, 'tag' => 'dev'})

      # Tests update cc api_key
      response = ADMIN_CLIENT.security.update_cross_cluster_api_key(
        id: id,
        body: {
          access: {
            replication: [{ names: ["archive"] }]
          },
          metadata: { "tag": "prod" }
        }
      )
      expect(response['updated']).to be true

      response = ADMIN_CLIENT.security.get_api_key(id: id, with_limited_by: true)
      expect(response['api_keys'].length).to eq 1
      api_key = response['api_keys'].first
      expect(api_key['name']) == 'my-cc-api-key'
      expect(api_key['type']) == 'cross_cluster'
      expect(api_key['invalidated']).to be false
      expect(api_key['metadata']).to eq({'tag' => 'prod'})
    end
  end
end
