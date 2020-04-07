# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cat#nodeattrs' do

  let(:expected_args) do
    [
        'GET',
        '_cat/nodeattrs',
        {},
        nil,
        {}
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.nodeattrs).to eq({})
  end
end
