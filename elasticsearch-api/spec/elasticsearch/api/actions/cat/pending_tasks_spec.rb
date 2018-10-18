require 'spec_helper'

describe 'client.cat#pending_tasks' do

  let(:expected_args) do
    [
        'GET',
        '_cat/pending_tasks',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.pending_tasks).to eq({})
  end
end
