require 'spec_helper'

describe 'client.remote#info' do

  let(:expected_args) do
    [
        'GET',
        '_remote/info',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.remote.info).to eq({})
  end
end
