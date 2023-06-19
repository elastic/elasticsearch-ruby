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

describe 'analytics/usage stats API' do
  let(:index) { 'analytics_test' }
  before do
    body = [
      {"index": {}},
      {"timestamp": "2017-01-01T05:00:00Z", "s": 1, "v1": 3.1415, "v2": 2.1415, "str": "a"},
      {"index": {}},
      {"timestamp": "2017-01-01T05:00:00Z", "s": 2, "v1": 1.0, "v2": 2.0, "str": "a"},
      {"index": {}},
      {"timestamp": "2017-01-01T05:00:00Z", "s": 3, "v1": 2.71828, "v2": 3.71828, "str": "b"},
    ]
    ADMIN_CLIENT.bulk(body: body, index: index, refresh: true)
  end

  after do
    ADMIN_CLIENT.indices.delete(index: index)
  end

  it 'gets memory for all nodes' do
    response = ADMIN_CLIENT.xpack.usage
    expect(response['analytics']['available']).to eq true
    expect(response['analytics']['enabled']).to eq true

    boxplot_usage = response['analytics']['stats']['boxplot_usage']

    response = ADMIN_CLIENT.search(
      index: index,
      body: { size: 0, aggs: { plot: { boxplot: { field: 's' } } } }
    )
    expect(response['aggregations']['plot']['q2']).to eq 2.0

    response = ADMIN_CLIENT.xpack.usage
    expect(response['analytics']['available']).to eq true
    expect(response['analytics']['enabled']).to eq true
    expect(response['analytics']['stats']['boxplot_usage']).to be > boxplot_usage
  end
end
