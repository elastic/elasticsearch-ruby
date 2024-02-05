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

describe 'security/Query User' do
  before do
    ADMIN_CLIENT.security.put_user(
      username: "query_users_test",
      body: {
        password: "x-pack-test-password",
        roles: [ "manage_users_role" ],
        full_name: "Read User"
      }
    )
  end

  it 'queries users' do
    response = ADMIN_CLIENT.security.query_user(body: {})
    expect(response.status).to eq 200
    expect(response['count']).to be > 0
    expect(response['total']).to be > 0
  end

  it 'queries user and finds created one' do
    body = {
      query: { wildcard: { username: 'query_users_*' } }
    }
    response = ADMIN_CLIENT.security.query_user(body: body)
    expect(response.status).to eq 200
    expect(response['count']).to be 1
    expect(response['total']).to be 1
    expect(response['users'].first['username']).to eq 'query_users_test'
  end
end
