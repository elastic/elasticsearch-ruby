# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#get_source' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil
    ]
  end

  let(:params) do
    { }
  end

  let(:url) do
    'foo/_source/1'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.get_source(id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.get_source(index: 'foo')
    }.to raise_exception(ArgumentError)
  end

  context 'when URL parameters are provided' do
    let(:params) do
      { routing: 'abc123' }
    end

    it 'Passes the URL params' do
      expect(client_double.get_source(index: 'foo', id: '1', routing: 'abc123')).to eq({})
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_source/1'
    end

    it 'URL-escapes the parts' do
      expect(client_double.get_source(index: 'foo^bar', id: '1')).to eq({})
    end
  end

  context 'when the request raises a NotFound error' do

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises the error' do
      expect {
        client.get_source(index: 'foo', id: '1')
      }.to raise_exception(NotFound)
    end
  end
end
