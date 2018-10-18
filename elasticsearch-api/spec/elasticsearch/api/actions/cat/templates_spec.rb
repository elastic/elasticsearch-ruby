require 'spec_helper'

describe 'client.cat#templates' do

  let(:expected_args) do
    [
        'GET',
        '_cat/templates',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.templates).to eq({})
  end
end
