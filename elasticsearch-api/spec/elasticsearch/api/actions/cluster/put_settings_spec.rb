require 'spec_helper'

describe 'client.cluster#put_settings' do

  let(:expected_args) do
    [
        'PUT',
        '_cluster/settings',
        {},
        {},
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.put_settings).to eq({})
  end
end
