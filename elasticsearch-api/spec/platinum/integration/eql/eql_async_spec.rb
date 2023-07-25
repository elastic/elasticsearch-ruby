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

describe 'eql/Executes async EQL with missing events' do
  let(:index) { 'eql_test_m' }
  before do
    ADMIN_CLIENT.indices.create(
      index: index,
      body: {
        mappings: {
          properties: {
            '@timestamp' => { type: 'date' },
            'event.category' => { type: 'keyword' },
            user: { type: 'keyword' }
          }
        }
      }
    )
    ADMIN_CLIENT.bulk(
      refresh: true,
      body: [
        { index: { _index: 'eql_test_m', _id: '1' } },
        { event: [{ category: 'process' }], '@timestamp' => '2023-07-11T11:09:05.529Z', user: 'foo' },
        { index: { _index: 'eql_test_m', _id: '2'} },
        { event: [{ category: 'process' }], '@timestamp' => '2023-07-11T11:09:06.529Z', user: 'bar' }
      ]
    )
  end

  after do
    ADMIN_CLIENT.indices.delete(index: index)
  end

  it 'Executes async EQL with missing events' do
    response = ADMIN_CLIENT.eql.search(
      index: 'eql_test_m',
      wait_for_completion_timeout: '0ms',
      keep_on_completion: true,
      body: { query: 'sequence with maxspan=24h [ process where true ] ![ process where true ]' }
    )
    expect(response.status).to eq 200
    expect(response['id']).not_to be_nil
    id = response['id']

    response = ADMIN_CLIENT.eql.get(id: id, wait_for_completion_timeout: '10s')
    expect(response.status).to eq 200
    expect(response['is_running']).to be false
    expect(response['is_partial']).to be false
    expect(response['timed_out']).to be false
    expect(response['hits']['total']['value']).to eq 1
    expect(response['hits']['total']['relation']).to eq 'eq'
    expect(response['hits']['total']['relation']).to eq 'eq'
    expect(response['hits']['sequences'].first['events'].first['_source']['user']).to eq 'bar'
    expect(response['hits']['sequences'].first['events'].last['missing']).to be true
  end
end
