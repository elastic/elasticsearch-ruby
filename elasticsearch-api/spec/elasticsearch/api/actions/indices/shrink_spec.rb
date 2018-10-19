require 'spec_helper'

describe 'client.cluster#shrink' do

  let(:expected_args) do
    [
        'PUT',
        'foo/_shrink/bar',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.shrink(index: 'foo', target: 'bar')).to eq({})
  end

  it 'does not mutate the arguments' do
    arguments = { index: 'foo', target: 'bar' }
    client_double.indices.shrink(arguments)
    expect(arguments[:index]).to eq('foo')
    expect(arguments[:target]).to eq('bar')
  end
end
