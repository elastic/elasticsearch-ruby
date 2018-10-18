require 'spec_helper'

describe 'client.cat#master' do

  let(:expected_args) do
    [
        'GET',
        '_cat/master',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.master).to eq({})
  end
end
