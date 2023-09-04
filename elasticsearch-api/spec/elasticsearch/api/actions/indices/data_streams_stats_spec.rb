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

describe 'client.indices#data_streams_stats' do
  let(:expected_args) do
    [
      'GET',
      url,
      params,
      nil,
      {},
      { endpoint: 'indices.data_streams_stats' }
    ]
  end

  let(:params) do
    {}
  end

  context 'when there is no name specified' do
    let(:url) do
      '_data_stream/_stats'
    end

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'performs the request' do
      expect(client_double.indices.data_streams_stats).to be_a Elasticsearch::API::Response
    end
  end

  context 'when name is specified' do
    let(:url) do
      '_data_stream/foo/_stats'
    end

    let(:expected_args) do
      [
        'GET',
        url,
        params,
        nil,
        {},
        { defined_params: { name: 'foo' }, endpoint: 'indices.data_streams_stats' }
      ]
    end

    it 'performs the request' do
      expect(client_double.indices.data_streams_stats(name: 'foo')).to be_a Elasticsearch::API::Response
    end
  end
end
