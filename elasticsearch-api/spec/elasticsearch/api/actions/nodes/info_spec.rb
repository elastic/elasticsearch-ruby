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

describe 'client.nodes#info' do

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
    '_nodes'
  end

  it 'performs the request' do
    expect(client_double.nodes.info).to eq({})
  end

  let(:params) do
    {}
  end

  context 'when the node id is specified' do

    let(:url) do
      '_nodes/foo'
    end

    it 'performs the request' do
      expect(client_double.nodes.info(node_id: 'foo')).to eq({})
    end
  end

  context 'when multiple node ids are specified as a list' do

    let(:url) do
      '_nodes/A,B,C'
    end

    it 'performs the request' do
      expect(client_double.nodes.info(node_id: ['A', 'B', 'C'])).to eq({})
    end
  end

  context 'when multiple node ids are specified as a String' do

    let(:url) do
      '_nodes/A,B,C'
    end

    it 'performs the request' do
      expect(client_double.nodes.info(node_id: 'A,B,C')).to eq({})
    end
  end

  context 'when URL params are specified' do

    let(:url) do
      '_nodes'
    end

    let(:params) do
      { format: 'yaml' }
    end

    it 'performs the request' do
      expect(client_double.nodes.info(format: 'yaml')).to eq({})
    end
  end

  context 'when metrics are specified' do

    let(:url) do
      '_nodes/http,network'
    end

    it 'performs the request' do
      expect(client_double.nodes.info(metric: ['http', 'network'])).to eq({})
    end
  end
end
