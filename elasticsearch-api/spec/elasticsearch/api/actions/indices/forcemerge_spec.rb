require 'spec_helper'

describe 'client.cluster#forcemerge' do

  let(:expected_args) do
    [
        'POST',
        '_forcemerge',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.forcemerge).to eq({})
  end
end
