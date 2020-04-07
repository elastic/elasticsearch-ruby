# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#create_document' do

  let(:expected_args) do
    [
        'PUT',
        'foo/_doc/123',
        { op_type: 'create' },
        { foo: 'bar' },
        {}
    ]
  end

  it 'performs the request' do
    expect(client_double.create(index: 'foo', id: '123', body: { foo: 'bar'})).to eq({})
  end

  context 'when the request needs to be URL-escaped' do

    let(:expected_args) do
      [
          'PUT',
          'foo/_doc/123',
          { op_type: 'create' },
          {},
          {}
      ]
    end

    it 'performs the request' do
      expect(client_double.create(index: 'foo', id: '123', body: {})).to eq({})
    end
  end

  context 'when an id is provided as an integer' do

    let(:expected_args) do
      [
          'PUT',
          'foo/_doc/1',
          { op_type: 'create' },
          { foo: 'bar' },
          {}
      ]
    end

    it 'updates the arguments with the `op_type`' do
      expect(client_double.create(index: 'foo', id: 1, body: { foo: 'bar' })).to eq({})
    end
  end

  context 'when an id is not provided' do

    let(:expected_args) do
      [
          'POST',
          'foo/_doc',
          { },
          { foo: 'bar' },
          {}
      ]
    end

    it 'updates the arguments with the `op_type`' do
      expect(client_double.create(index: 'foo', body: { foo: 'bar' })).to eq({})
    end
  end
end
