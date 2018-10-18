require 'spec_helper'

describe 'client.cluster#stats' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/stats',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.stats).to eq({})
  end
end
