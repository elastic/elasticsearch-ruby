# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.indices#delete_warmer' do

  let(:expected_args) do
    [
        'DELETE',
        url,
        params,
        nil,
        nil
    ]
  end

  let(:params) do
    {}
  end

  context 'when an index is not specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.delete_warmer
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_warmer'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_warmer(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_warmer'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_warmer(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when a single warmer is specified' do

    let(:url) do
      'foo/_warmer/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_warmer(index: 'foo', name: 'bar')).to eq({})
    end
  end

  context 'when a multiple warmers are specified' do

    let(:url) do
      'foo/_warmer/bar,baz'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_warmer(index: 'foo', name: ['bar', 'baz'])).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_warmer/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_warmer(index: 'foo^bar', name: 'bar/bam')).to eq({})
    end
  end
end
