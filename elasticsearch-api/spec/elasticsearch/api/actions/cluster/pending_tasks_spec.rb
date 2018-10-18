require 'spec_helper'

describe 'client.cluster#pending_tasks' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/pending_tasks',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.pending_tasks).to eq({})
  end
end
