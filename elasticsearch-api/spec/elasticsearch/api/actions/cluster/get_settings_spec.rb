require 'spec_helper'

describe 'client.cluster#get_settings' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/settings',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.get_settings).to eq({})
  end
end
