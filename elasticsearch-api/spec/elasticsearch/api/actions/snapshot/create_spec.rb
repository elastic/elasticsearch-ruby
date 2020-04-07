# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.snapshot#create' do

  let(:expected_args) do
    [
        'PUT',
        '_snapshot/foo/bar',
        {},
        {},
        {}
    ]
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :repository argument' do
    expect {
      client.snapshot.create(snapshot: 'bar', body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :snapshot argument' do
    expect {
      client.snapshot.create(repository: 'foo', body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.snapshot.create(repository: 'foo', snapshot: 'bar', body: {})).to eq({})
  end
end
