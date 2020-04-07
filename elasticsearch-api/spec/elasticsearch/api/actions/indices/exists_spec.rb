# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.indices#exists' do

  let(:expected_args) do
    [
        'HEAD',
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
    'foo'
  end

  it 'performs the request' do
    expect(client_double.indices.exists(index: 'foo')).to eq(true)
  end

  it 'aliased to a predicate method' do
    expect(client_double.indices.exists?(index: 'foo')).to eq(true)
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar'
    end

    it 'performs the request' do
      expect(client_double.indices.exists(index: ['foo','bar'])).to eq(true)
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.indices.exists(index: 'foo^bar')).to eq(true)
    end
  end

  context 'when 404 response is received' do

    let(:response_double) do
      double('response', status: 404, body: {}, headers: {})
    end

    it 'returns false' do
      expect(client_double.indices.exists(index: 'foo')).to eq(false)
    end
  end

  context 'when a \'not found\' exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(StandardError.new('404 Not Found'))
      end
    end

    it 'returns false' do
      expect(client.indices.exists(index: 'foo')).to eq(false)
    end
  end

  context 'when a generic exception is raised' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(StandardError.new)
      end
    end

    it 'raises the exception' do
      expect {
        client.indices.exists(index: 'foo')
      }.to raise_exception(StandardError)
    end
  end
end
