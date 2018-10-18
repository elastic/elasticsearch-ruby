require 'spec_helper'

describe 'client.cat#nodes' do

  let(:expected_args) do
    [
        'GET',
        '_cat/nodes',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.nodes).to eq({})
  end
end
