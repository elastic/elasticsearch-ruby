require 'spec_helper'

describe 'client#search' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body
    ]
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  let(:url) do
    '_all/foo/_search'
  end

  it 'has a default value for index' do
    expect(client_double.search(type: 'foo'))
  end

  context 'when a request definition is specified' do

    let(:body) do
      { query: { match: {} } }
    end

    let(:url) do
      '_search'
    end

    it 'performs the request' do
      expect(client_double.search(body: { query: { match: {} } }))
    end
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: 'foo'))
    end
  end

  context 'when an index and type are specified' do

    let(:url) do
      'foo/bar/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: 'foo', type: 'bar'))
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: ['foo', 'bar']))
    end
  end

  context 'when multiple indices and types are specified' do

    let(:url) do
      'foo,bar/lam,bam/_search'
    end

    it 'performs the request' do
      expect(client_double.search(index: ['foo', 'bar'], type: ['lam', 'bam']))
    end
  end

  context 'when there are URL params' do

    let(:url) do
      '_search'
    end

    let(:params) do
      { search_type: 'count' }
    end

    it 'performs the request' do
      expect(client_double.search(search_type: 'count'))
    end
  end

  context 'when there are invalid URL params' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an ArgumentError' do
      expect{
        client.search(search_type: 'count', qwertypoiuy: 'asdflkjhg')
      }.to raise_exception(ArgumentError)
    end
  end
end
