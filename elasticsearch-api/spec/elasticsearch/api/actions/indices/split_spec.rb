require 'spec_helper'

describe 'client.cluster#split' do

  let(:expected_args) do
    [
        'PUT',
        'foo/_split/bar',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.split(index: 'foo', target: 'bar')).to eq({})
  end
end
