require 'spec_helper'

describe 'client.cat#help' do

  let(:expected_args) do
    [
        'GET',
        '_cat',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.help).to eq({})
  end
end
