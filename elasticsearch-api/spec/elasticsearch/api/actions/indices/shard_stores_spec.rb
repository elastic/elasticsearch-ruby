require 'spec_helper'

describe 'client.cluster#shard_stores' do

  let(:expected_args) do
    [
        'GET',
        '_shard_stores',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.shard_stores).to eq({})
  end
end
