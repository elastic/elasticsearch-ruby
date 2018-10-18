require 'spec_helper'

describe 'client.cat#nodeattrs' do

  let(:expected_args) do
    [
        'GET',
        '_cat/nodeattrs',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.nodeattrs).to eq({})
  end
end
