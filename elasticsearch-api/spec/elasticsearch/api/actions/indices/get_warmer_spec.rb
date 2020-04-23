# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.indices#get_warmer' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil,
        nil
    ]
  end

  let(:params) do
    {}
  end

  let(:url) do
    '_all/_warmer'
  end

  it 'performs the request' do
    expect(client_double.indices.get_warmer(index: '_all')).to eq({})
  end

  context 'when a specified warmer is specified' do

    let(:url) do
      'foo/_warmer/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.get_warmer(index: 'foo', name: 'bar')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_warmer/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.get_warmer(index: 'foo^bar', name: 'bar/bam')).to eq({})
    end
  end
end
