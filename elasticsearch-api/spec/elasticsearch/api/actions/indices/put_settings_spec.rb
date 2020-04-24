# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.cluster#put_settings' do

  let(:expected_args) do
    [
        'PUT',
        url,
        params,
        body,
        nil
    ]
  end

  let(:url) do
    '_settings'
  end

  let(:body) do
    {}
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.put_settings(body: {})).to eq({})
  end

  context 'when there is no body specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_settings
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.put_settings(index: 'foo', body: {})).to eq({})
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.put_settings(index: ['foo','bar'], body: {})).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_settings'
    end

    it 'performs the request' do
      expect(client_double.indices.put_settings(index: 'foo^bar', body: {})).to eq({})
    end
  end
end
