require 'spec_helper'

describe 'client.indices#delete_alias' do

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
        client.indices.delete_alias(name: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when there is no name specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.delete_alias(index: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when an index and name are specified' do

    let(:url) do
      'foo/_alias/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_alias(index: 'foo', name: 'bar')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_alias/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.delete_alias(index: 'foo^bar', name: 'bar/bam')).to eq({})
    end
  end
end
