require 'spec_helper'

describe 'client.snapshot#get_repository' do

  let(:expected_args) do
    [
        'GET',
        '_snapshot/foo',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.snapshot.get_repository(repository: 'foo')).to eq({})
  end
end
