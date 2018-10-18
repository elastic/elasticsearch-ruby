require 'spec_helper'

describe 'client.cat#thread_pool' do

  let(:expected_args) do
    [
        'GET',
        '_cat/thread_pool',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.thread_pool).to eq({})
  end
end
