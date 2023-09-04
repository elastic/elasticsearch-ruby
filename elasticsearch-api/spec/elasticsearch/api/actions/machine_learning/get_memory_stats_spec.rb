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

describe 'client#ml.get_memory_stats' do

  let(:expected_args) do
    [
      'GET',
      url,
      {},
      nil,
      {},
      { endpoint: 'ml.get_memory_stats' }
    ]
  end

  context 'without a node id' do
    let(:url) { '_ml/memory/_stats' }

    it 'performs the request' do
      expect(client_double.ml.get_memory_stats).to be_a Elasticsearch::API::Response
    end
  end

  context 'with a node id' do
    let(:url) { '_ml/memory/foo/_stats' }

    let(:expected_args) do
      [
        'GET',
        url,
        {},
        nil,
        {},
        { defined_params: { node_id: 'foo' }, endpoint: 'ml.get_memory_stats' }
      ]
    end

    it 'performs the request' do
      expect(client_double.ml.get_memory_stats(node_id: 'foo')).to be_a Elasticsearch::API::Response
    end
  end
end
