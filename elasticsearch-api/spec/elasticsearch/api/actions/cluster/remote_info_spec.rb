require 'spec_helper'

describe 'client.cluster#remote_info' do

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
    expect(client_double.cluster.remote_info).to eq({})
  end
end
