require 'spec_helper'

describe 'client.cat#plugins' do

  let(:expected_args) do
    [
        'GET',
        '_cat/plugins',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.plugins).to eq({})
  end
end
