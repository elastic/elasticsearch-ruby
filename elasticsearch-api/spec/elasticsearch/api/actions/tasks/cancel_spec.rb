require 'spec_helper'

describe 'client.tasks#cancel' do

  let(:expected_args) do
    [
        'POST',
        url,
        {},
        nil,
        nil
    ]
  end

  let(:url) do
    '_tasks/_cancel'
  end

  it 'performs the request' do
    expect(client_double.tasks.cancel).to eq({})
  end

  context 'when a task id is specified' do

    let(:url) do
      '_tasks/foo/_cancel'
    end

    it 'performs the request' do
      expect(client_double.tasks.cancel(task_id: 'foo')).to eq({})
    end
  end
end
