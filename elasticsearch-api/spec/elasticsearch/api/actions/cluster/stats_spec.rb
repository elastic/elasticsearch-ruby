# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#stats' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/stats',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.stats).to eq({})
  end

  context 'when a node_id is specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/stats/nodes/1',
          {},
          nil,
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.stats(node_id: 1)).to eq({})
    end
  end
end
