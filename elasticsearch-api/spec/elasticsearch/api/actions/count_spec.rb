# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#count' do

  let(:expected_args) do
    [
      'GET',
      '_count',
      {},
      nil,
      {}
    ]
  end

  it 'performs the request' do
    expect(client_double.count).to eq({})
  end

  context 'when an index and type are specified' do

    let(:expected_args) do
      [
        'GET',
        'foo,bar/t1,t2/_count',
        {},
        nil,
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.count(index: ['foo','bar'], type: ['t1','t2'])).to eq({})
    end
  end

  context 'when there is a query provided' do

    let(:expected_args) do
      [
        'POST',
        '_count',
        {},
        { match: { foo: 'bar' } },
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.count(body: { match: { foo: 'bar' } })).to eq({})
    end
  end
end
