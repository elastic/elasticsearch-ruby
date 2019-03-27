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
