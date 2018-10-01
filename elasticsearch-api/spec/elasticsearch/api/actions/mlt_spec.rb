require 'spec_helper'

describe 'client#mlt' do

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

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.mlt(type: 'bar', id: '1')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :id argument' do
    expect {
      client.mlt(index: 'foo', type: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :type argument' do
    expect {
      client.mlt(index: 'foo', id: '1')
    }.to raise_exception(ArgumentError)
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/bar/1/_mlt'
    end

    it 'performs the request' do
      expect(client_double.mlt(index: 'foo', type: 'bar', id: '1')).to eq({})
    end
  end

  context 'when url parameters are provided' do

    let(:url) do
      'foo/bar/1/_mlt'
    end

    let(:params) do
      { max_doc_freq: 1 }
    end

    it 'performs the request' do
      expect(client_double.mlt(index: 'foo', type: 'bar', id: '1', max_doc_freq: 1)).to eq({})
    end
  end

  context 'when url parameters as lists are provided' do

    let(:url) do
      'foo/bar/1/_mlt'
    end

    let(:params) do
      { mlt_fields: 'foo,bar',
        search_indices: 'A,B',
        search_types: 'X,Y',
        stop_words: 'lam,bam' }
    end

    it 'performs the request' do
      expect(client_double.mlt( index: 'foo', type: 'bar', id: '1',
                                mlt_fields: ['foo', 'bar'],
                                search_indices: ['A', 'B'],
                                search_types: ['X', 'Y'],
                                stop_words: ['lam','bam'])).to eq({})
    end
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/1/_mlt'
    end

    it 'performs the request' do
      expect(client_double.mlt(index: 'foo^bar', type: 'bar/bam', id: '1')).to eq({})
    end
  end

  context 'when a search criteria is provided' do

    let(:url) do
      'foo/bar/1/_mlt'
    end

    let(:body) do
      { query: {} }
    end

    it 'passes the search definition in the body' do
      expect(client_double.mlt(index: 'foo', type: 'bar', id: '1', body: { query: {} })).to eq({})
    end
  end
end
