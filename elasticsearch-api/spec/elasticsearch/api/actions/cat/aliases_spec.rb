require 'spec_helper'

describe 'client.cat#aliases' do

  let(:expected_args) do
    [
        'GET',
        '_cat/aliases',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.aliases).to eq({})
  end
end
