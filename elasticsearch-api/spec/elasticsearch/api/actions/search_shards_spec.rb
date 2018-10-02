require 'spec_helper'

describe 'client#search_shards' do

  let(:expected_args) do
    [
        'GET',
        '_search_shards',
        { },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.search_shards).to eq({})
  end
end
