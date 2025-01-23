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

require 'spec_helper'

describe 'client.connector#last_sync' do
  let(:expected_args) do
    [
      'PUT',
      '_connector/foo/_last_sync',
      {},
      {},
      {},
      {
        :defined_params=>{ connector_id: 'foo' },
        endpoint: 'connector.last_sync'
      }
    ]
  end

  it 'performs the request' do
    expect(client_double.connector.last_sync(connector_id: 'foo', body: {})).to be_a Elasticsearch::API::Response
  end
end
