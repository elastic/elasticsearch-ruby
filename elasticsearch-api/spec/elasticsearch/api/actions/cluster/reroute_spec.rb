require 'spec_helper'

describe 'client.cluster#reroute' do

  let(:expected_args) do
    [
        'POST',
        '_cluster/reroute',
        {},
        {},
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.reroute).to eq({})
  end

  context 'when a body is specified' do

    let(:expected_args) do
      [
          'POST',
          '_cluster/reroute',
          {},
          { commands: [ move: { index: 'myindex', shard: 0 }] },
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.reroute(body: { commands: [ move: { index: 'myindex', shard: 0 }] })).to eq({})
    end
  end
end
