# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#msearch' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body,
        headers
    ]
  end

  let(:body) do
    nil
  end

  let(:url) do
    '_msearch'
  end

  let(:params) do
    {}
  end

  let(:headers) do
    { 'Content-Type' => 'application/x-ndjson' }
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :body argument' do
    expect {
      client.msearch
    }.to raise_exception(ArgumentError)
  end

  context 'when the body is an object' do

    let(:body) do
      <<-PAYLOAD.gsub(/^\s+/, '')
            {"index":"foo"}
            {"query":{"match_all":{}}}
            {"index":"bar"}
            {"query":{"match":{"foo":"bar"}}}
            {"search_type":"count"}
            {"facets":{"tags":{}}}
      PAYLOAD
    end

    it 'performs the request' do
      expect(client_double.msearch body: [
          { index: 'foo', search: { query: { match_all: {}  } } },
          { index: 'bar', search: { query: { match: { foo: 'bar' } } } },
          { search_type: 'count', search: { facets: { tags: {} } } }
      ])
    end
  end

  context 'when the body is a string' do

    let(:body) do
      %Q|{"foo":"bar"}\n{"moo":"lam"}|
    end

    it 'performs the request' do
      expect(client_double.msearch(body: %Q|{"foo":"bar"}\n{"moo":"lam"}|)).to eq({})
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_msearch'
    end

    let(:body) do
      ''
    end

    it 'performs the request' do
      expect(client_double.msearch(index: 'foo', body: []))
    end
  end

  context 'when a type and index are specified' do

    let(:url) do
      'foo/bar/_msearch'
    end

    let(:body) do
      ''
    end

    it 'performs the request' do
      expect(client_double.msearch(index: 'foo', type: 'bar', body: []))
    end
  end

  context 'when multiple indices and multiple types are specified' do

    let(:url) do
      'foo,bar/lam,bam/_msearch'
    end

    let(:body) do
      ''
    end

    it 'performs the request' do
      expect(client_double.msearch(index: ['foo', 'bar'], type: ['lam', 'bam'], body: []))
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/_msearch'
    end

    let(:body) do
      ''
    end

    it 'performs the request' do
      expect(client_double.msearch(index: 'foo^bar', type: 'bar/bam', body: [])).to eq({})
    end
  end

  context 'when the URL params need to be URL-encoded' do

    let(:url) do
      '_msearch'
    end

    let(:body) do
      ''
    end

    let(:params) do
      { search_type: 'scroll' }
    end

    it 'performs the request' do
      expect(client_double.msearch(body: [], search_type: 'scroll')).to eq({})
    end
  end
end
