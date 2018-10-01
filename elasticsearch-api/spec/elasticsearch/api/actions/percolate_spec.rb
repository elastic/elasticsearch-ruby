require 'spec_helper'

describe 'client#percolate' do

  let(:expected_args) do
    [
        'GET',
        url,
        { },
        body
    ]
  end

  let(:body) do
    { doc: { foo: 'bar' }}
  end

  let(:url) do
    'foo/bar/_percolate'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :index argument' do
    expect {
      client.percolate(type: 'bar', body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :type argument' do
    expect {
      client.percolate(index: 'foo', body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.percolate(index: 'foo', type: 'bar', body: { doc: { foo: 'bar' } })).to eq({})
  end

  context 'when the request needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/_percolate'
    end

    it 'URL-escapes the parts' do
      expect(client_double.percolate(index: 'foo^bar', type: 'bar/bam', body: { doc: { foo: 'bar' } })).to eq({})
    end
  end

  context 'when the document id needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam/some%2Fid/_percolate'
    end

    let(:body) do
      nil
    end

    it 'URL-escapes the id' do
      expect(client_double.percolate(index: 'foo^bar', type: 'bar/bam', id: 'some/id')).to eq({})
    end
  end
end
