require 'spec_helper'

describe 'client.cat#tasks' do

  let(:expected_args) do
    [
        'GET',
        '_cat/tasks',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.tasks).to eq({})
  end
end
