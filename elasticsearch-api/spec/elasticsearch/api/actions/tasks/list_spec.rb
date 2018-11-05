require 'spec_helper'

describe 'client.tasks#list' do

  let(:expected_args) do
    [
        'GET',
        url,
        {},
        nil,
        nil
    ]
  end

  let(:url) do
    '_tasks'
  end

  it 'performs the request' do
    expect(client_double.tasks.list).to eq({})
  end

  context 'when a task id is specified' do

    let(:url) do
      '_tasks/foo'
    end

    it 'performs the request' do
      expect(client_double.tasks.list(task_id: 'foo')).to eq({})
    end
  end
end
