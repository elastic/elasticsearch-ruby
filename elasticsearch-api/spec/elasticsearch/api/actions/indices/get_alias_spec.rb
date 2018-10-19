require 'spec_helper'

describe 'client.cluster#get_alias' do

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
    '_alias/foo'
  end

  it 'performs the request' do
    expect(client_double.indices.get_alias(name: 'foo')).to eq({})
  end

  context 'when multiple indices are specified' do

    let(:url) do
      'foo,bar/_alias/bam'
    end

    it 'performs the request' do
      expect(client_double.indices.get_alias(index: ['foo','bar'], name: 'bam')).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_alias/bar%2Fbam'
    end

    it 'performs the request' do
      expect(client_double.indices.get_alias(index: 'foo^bar', name: 'bar/bam')).to eq({})
    end
  end
end
