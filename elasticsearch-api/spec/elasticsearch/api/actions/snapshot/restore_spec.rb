# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.snapshot#restore' do

  let(:expected_args) do
    [
        'POST',
        '_snapshot/foo/bar/_restore',
        {},
        nil,
        {}
    ]
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :snapshot argument' do
    expect {
      client.snapshot.restore(repository: 'foo')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :repository argument' do
    expect {
      client.snapshot.restore(snapshot: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.snapshot.restore(repository: 'foo', snapshot: 'bar')).to eq({})
  end
end
