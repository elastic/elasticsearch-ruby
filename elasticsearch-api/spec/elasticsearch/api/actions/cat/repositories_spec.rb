require 'spec_helper'

describe 'client.cat#repositories' do

  let(:expected_args) do
    [
        'GET',
        '_cat/repositories',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.repositories).to eq({})
  end
end
