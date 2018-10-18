require 'spec_helper'

describe 'client.cat#shards' do

  let(:expected_args) do
    [
        'GET',
        '_cat/shards',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.shards).to eq({})
  end
end
