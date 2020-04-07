# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.tasks#cancel' do

  let(:expected_args) do
    [
        'POST',
        url,
        {},
        nil,
        {}
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
