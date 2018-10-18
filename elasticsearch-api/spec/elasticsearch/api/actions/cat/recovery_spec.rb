require 'spec_helper'

describe 'client.cat#recovery' do

  let(:expected_args) do
    [
        'GET',
        '_cat/recovery',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.recovery).to eq({})
  end
end
