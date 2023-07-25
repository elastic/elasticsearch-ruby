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

describe 'ML/Get Memory Stats API' do
  it 'gets memory for all nodes' do
    response = ADMIN_CLIENT.ml.get_memory_stats
    expect(response.status).to eq 200
    expect(response['cluster_name']).not_to be_nil
    expect(response['_nodes']['total']).to be >= 1
    expect(response['nodes'].first[1]['mem']['total_in_bytes']).to be > 1
  end

  it 'gets memory for ML nodes' do
    response = ADMIN_CLIENT.ml.get_memory_stats
    expect(response.status).to eq 200
    expect(response['cluster_name']).not_to be_nil
    expect(response['nodes'].first[1]['mem']['total_in_bytes']).to be > 1
  end

  it 'gets memory for specific node' do
    response = ADMIN_CLIENT.ml.get_memory_stats
    expect(response.status).to eq 200
    node_id = response['nodes'].keys.first

    response = ADMIN_CLIENT.ml.get_memory_stats(node_id: node_id, timeout: '29s')
    expect(response.status).to eq 200
    expect(response['cluster_name']).not_to be_nil
    expect(response['nodes'].first[1]['mem']['total_in_bytes']).to be > 1
    expect(response['_nodes']['total']).to be 1
  end
end
