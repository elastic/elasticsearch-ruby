require 'spec_helper'

describe 'client.cluster#seal' do

  let(:expected_args) do
    [
        'POST',
        'foo/_seal',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.seal(index: 'foo')).to eq({})
  end
end
