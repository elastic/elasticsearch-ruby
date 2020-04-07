# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#shrink' do

  let(:expected_args) do
    [
        'PUT',
        'foo/_shrink/bar',
        {},
        nil,
        {}
    ]
  end

  it 'performs the request' do
    expect(client_double.indices.shrink(index: 'foo', target: 'bar')).to eq({})
  end

  it 'does not mutate the arguments' do
    arguments = { index: 'foo', target: 'bar' }
    client_double.indices.shrink(arguments)
    expect(arguments[:index]).to eq('foo')
    expect(arguments[:target]).to eq('bar')
  end
end
