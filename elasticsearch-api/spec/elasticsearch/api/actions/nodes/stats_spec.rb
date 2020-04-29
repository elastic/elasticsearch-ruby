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

describe 'client.nodes#stats' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil,
        {}
    ]
  end

  let(:url) do
    '_nodes/stats'
  end

  it 'performs the request' do
    expect(client_double.nodes.stats).to eq({})
  end

  let(:params) do
    {}
  end

  context 'when the node id is specified' do

    let(:url) do
      '_nodes/foo/stats'
    end

    it 'performs the request' do
      expect(client_double.nodes.stats(node_id: 'foo')).to eq({})
    end
  end

  context 'when metrics are specified' do

    let(:url) do
      '_nodes/stats/http,fs'
    end

    it 'performs the request' do
      expect(client_double.nodes.stats(metric: [:http, :fs])).to eq({})
    end
  end

  context 'when index metric is specified' do

    let(:url) do
      '_nodes/stats/indices/filter_cache'
    end

    it 'performs the request' do
      expect(client_double.nodes.stats(metric: :indices, index_metric: :filter_cache)).to eq({})
    end
  end
end
