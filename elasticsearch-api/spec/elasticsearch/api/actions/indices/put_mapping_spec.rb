require 'spec_helper'

describe 'client.cluster#put_mapping' do

  let(:expected_args) do
    [
        'PUT',
        url,
        {},
        body,
        nil
    ]
  end

  let(:url) do
    'foo/_mapping/bar'
  end

  let(:body) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.put_mapping(index: 'foo', type: 'bar', body: {})).to eq({})
  end

  context 'when there is no type specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_mapping(type: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no body specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.put_mapping(index: 'foo', type: 'bar')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when a body is specified' do

    let(:body) do
      { filter: 'foo' }
    end

    it 'performs the request' do
      expect(client_double.indices.put_mapping(index: 'foo', type: 'bar', body: { filter: 'foo' })).to eq({})
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_mapping/bam'
    end

    it 'performs the request' do
      expect(client_double.indices.put_mapping(index: ['foo','bar'], type: 'bam', body: {})).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_mapping/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.put_mapping(index: 'foo^bar', type: 'bar/bam', body: {})).to eq({})
    end
  end
end
