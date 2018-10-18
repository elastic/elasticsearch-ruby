require 'spec_helper'

describe 'client.cat#allocation' do

  let(:expected_args) do
    [
        'GET',
        '_cat/allocation',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.allocation).to eq({})
  end
end
