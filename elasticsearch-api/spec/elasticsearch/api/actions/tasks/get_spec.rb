require 'spec_helper'

describe 'client.tasks#get' do

  let(:expected_args) do
    [
        'GET',
        '_tasks/foo1',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.tasks.get(task_id: 'foo1')).to eq({})
  end
end
