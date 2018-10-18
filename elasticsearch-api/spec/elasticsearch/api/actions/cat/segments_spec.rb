require 'spec_helper'

describe 'client.cat#segments' do

  let(:expected_args) do
    [
        'GET',
        '_cat/segments',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.segments).to eq({})
  end
end
