require 'spec_helper'

describe 'client.cluster#upgrade' do

  let(:expected_args) do
    [
        'POST',
        '_upgrade',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.upgrade).to eq({})
  end
end
