require 'spec_helper'

describe 'client.cat#indices' do

  let(:expected_args) do
    [
        'GET',
        '_cat/indices',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.indices).to eq({})
  end
end
