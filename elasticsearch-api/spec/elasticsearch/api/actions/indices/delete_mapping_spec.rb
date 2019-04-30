require 'spec_helper'

describe 'client.indices#delete_mapping' do

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

  context 'when there is no index specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.delete_mapping(type: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no type specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.delete_mapping(index: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index and type are specified' do

    let(:url) do
      'foo/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_mapping(index: 'foo', type: 'bar')).to eq({})
    end
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/baz'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_mapping(index: ['foo','bar'], type: 'baz')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_mapping(index: 'foo^bar', type: 'bar/bam')).to eq({})
    end
  end
end
