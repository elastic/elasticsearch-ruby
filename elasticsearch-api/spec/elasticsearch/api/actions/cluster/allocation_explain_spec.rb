require 'spec_helper'

describe 'client.cluster#allocation_explain' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/allocation/explain',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.allocation_explain).to eq({})
  end
end
