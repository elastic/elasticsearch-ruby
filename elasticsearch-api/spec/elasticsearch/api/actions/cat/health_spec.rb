require 'spec_helper'

describe 'client.cat#health' do

  let(:expected_args) do
    [
        'GET',
        '_cat/health',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.health).to eq({})
  end
end
