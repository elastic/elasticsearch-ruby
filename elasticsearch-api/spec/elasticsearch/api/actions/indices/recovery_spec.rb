require 'spec_helper'

describe 'client.cluster#recovery' do

  let(:expected_args) do
    [
        'GET',
        'foo/_recovery',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.recovery(index: 'foo')).to eq({})
  end
end
