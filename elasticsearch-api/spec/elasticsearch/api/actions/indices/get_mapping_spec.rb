# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#get_mapping' do

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
    '_mapping'
  end

  it 'performs the request' do
    expect(client_double.indices.get_mapping).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_mapping'
    end

    it 'performs the request' do
      expect(client_double.indices.get_mapping(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_mapping'
    end

    it 'performs the request' do
      expect(client_double.indices.get_mapping(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_mapping'
    end

    it 'performs the request' do
      expect(client_double.indices.get_mapping(index: 'foo^bar', type: 'bar/bam')).to eq({})
    end
  end
end
