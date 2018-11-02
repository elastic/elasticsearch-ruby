require 'spec_helper'

describe 'client.snapshot#verify_repository' do

  let(:expected_args) do
    [
        'POST',
        '_snapshot/foo/_verify',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.snapshot.verify_repository(repository: 'foo')).to eq({})
  end
end
