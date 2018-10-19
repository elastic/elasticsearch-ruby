require 'spec_helper'

describe 'client.cluster#get_mapping' do

  let(:expected_args) do
    [
        'GET',
        url,
        {},
        nil,
        nil
    ]
  end

  let(:url) do
    '_mapping'
  end

  it 'performs the request' do
    expect(client_double.indices.get_mapping).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_mapping'
    end

    it 'performs the request' do
      expect(client_double.indices.get_mapping(index: 'foo')).to eq({})
    end
  end

  context 'when an index and type are specified' do

    let(:url) do
      'foo/_mapping/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.get_mapping(index: 'foo', type: 'bar')).to eq({})
    end
  end

  context 'when multiple indices and types are specified' do

    let(:url) do
      'foo,bar/_mapping/bam,baz'
    end

    it 'performs the request' do
      expect(client_double.indices.get_mapping(index: ['foo', 'bar'], type: ['bam', 'baz'])).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_mapping/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.get_mapping(index: 'foo^bar', type: 'bar/bam')).to eq({})
    end
  end
end
