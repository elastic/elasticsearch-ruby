# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
