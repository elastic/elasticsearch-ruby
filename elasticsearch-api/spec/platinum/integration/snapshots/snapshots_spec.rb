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

describe 'Snapshots API' do
  before do
    ADMIN_CLIENT.snapshot.create_repository(
      repository: 'test_repo_restore_1',
      body: {
        type: 'source',
        settings: {
          delegate_type: 'fs',
          location: "test_repo_restore_1_loc"
        }
      }
    )
    ADMIN_CLIENT.indices.create(
      index: index,
      body: {
        settings: {
          number_of_shards: 1,
          number_of_replicas: 0
        }
      }
    )
  end

  after do
    ADMIN_CLIENT.indices.delete(index: 'test_index')
    ADMIN_CLIENT.snapshot.delete(repository: 'test_repo_restore_1', snapshot: 'test_snapshot')
  end

  let(:index) { 'test_index' }

  it 'creates a source only snapshot and then restores it' do
    ADMIN_CLIENT.index(index: index, id: '1', body: { foo: 'bar' })
    ADMIN_CLIENT.indices.flush(index: index)
    response = ADMIN_CLIENT.snapshot.create(
      repository: 'test_repo_restore_1',
      snapshot: 'test_snapshot',
      wait_for_completion: true,
      body: { "indices": "test_index" }
    )
    expect(response.status).to eq 200
    expect(response['snapshot']['snapshot']).to eq 'test_snapshot'
    expect(response['snapshot']['state']).to eq 'SUCCESS'
    expect(response['snapshot']['version']).not_to be_nil

    ADMIN_CLIENT.indices.close(index: index)
    ADMIN_CLIENT.snapshot.restore(
      repository: 'test_repo_restore_1',
      snapshot: 'test_snapshot',
      wait_for_completion: true,
    )
    response = ADMIN_CLIENT.indices.recovery(index: 'test_index')
    expect(response.status).to eq 200
    expect(response['test_index']['shards'].first['type']).to eq 'SNAPSHOT'
    expect(response['test_index']['shards'].first['stage']).to eq 'DONE'
    response = ADMIN_CLIENT.search(
      rest_total_hits_as_int: true,
      index: index,
      body: { query: { match_all: {} } }
    )
    expect(response.status).to eq 200
    expect(response['hits']['total']).to eq 1
    expect(response['hits']['hits'].length).to eq 1
    expect(response['hits']['hits'].first['_id']).to eq '1'
  end
end
