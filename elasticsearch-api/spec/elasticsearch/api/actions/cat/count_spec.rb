require 'spec_helper'

describe 'client.cat#count' do

  let(:expected_args) do
    [
        'GET',
        '_cat/count',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.count).to eq({})
  end
end
