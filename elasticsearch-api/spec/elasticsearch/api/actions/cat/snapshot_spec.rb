require 'spec_helper'

describe 'client.cat#snapshots' do

  let(:expected_args) do
    [
        'GET',
        '_cat/snapshots/foo',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.snapshots(repository: 'foo')).to eq({})
  end
end
