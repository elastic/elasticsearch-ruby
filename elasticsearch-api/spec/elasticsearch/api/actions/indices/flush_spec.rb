# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.indices#flush' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        nil,
        {}
    ]
  end

  let(:params) do
    {}
  end

  let(:url) do
    '_flush'
  end

  it 'performs the request' do
    expect(client_double.indices.flush).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_flush'
    end

    it 'performs the request' do
      expect(client_double.indices.flush(index: 'foo')).to eq({})
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_flush'
    end

    it 'performs the request' do
      expect(client_double.indices.flush(index: ['foo','bar'])).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_flush'
    end

    it 'performs the request' do
      expect(client_double.indices.flush(index: 'foo^bar')).to eq({})
    end
  end

  context 'when URL parameters are specified' do

    let(:url) do
      'foo/_flush'
    end

    let(:params) do
      { ignore_unavailable: true }
    end

    it 'performs the request' do
      expect(client_double.indices.flush(index: 'foo', ignore_unavailable: true)).to eq({})
    end
  end
end
