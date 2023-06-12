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

describe 'Service Accounts API' do
  context 'service account tokens' do
    before do

    end

    after do
      ADMIN_CLIENT.security.delete_service_token(
        namespace: 'elastic',
        service: 'fleet-server',
        name: 'api-token-fleet'
      )
    end

    it 'responds with health report' do
      response = ADMIN_CLIENT.security.create_service_token(
        namespace: 'elastic',
        service: 'fleet-server',
        name: 'api-token-fleet'
      )
      expect(response.status).to eq 200
      expect(response['created']).to eq true
      service_token_fleet = response['token']['value']
      headers = { 'Authorization' => "Bearer #{service_token_fleet}"}
      client = Elasticsearch::Client.new(
        host: HOST,
        transport_options: TRANSPORT_OPTIONS.merge(headers: headers)
      )
      response = client.security.authenticate

      expect(response.status).to eq 200
      expect(response['username']).to eq 'elastic/fleet-server'
      expect(response['full_name']).to eq 'Service account - elastic/fleet-server'


      expect do
        client.security.delete_user(username: 'foo')
      end.to raise_error Elastic::Transport::Transport::Errors::Forbidden

      response = ADMIN_CLIENT.security.get_service_credentials(
        namespace: 'elastic', service: 'fleet-server'
      )
      expect(response['service_account']).to eq 'elastic/fleet-server'
    end
  end
end
