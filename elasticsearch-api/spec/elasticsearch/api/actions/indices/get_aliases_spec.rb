require 'spec_helper'

describe 'client.cluster#get_aliases' do

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
    '_aliases'
  end

  it 'performs the request' do
    expect(client_double.indices.get_aliases).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_aliases'
    end

    it 'performs the request' do
      expect(client_double.indices.get_aliases(index: 'foo')).to eq({})
    end
  end

  context 'when a specified alias is specified' do

    let(:url) do
      'foo/_aliases/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.get_aliases(index: 'foo', name: 'bar')).to eq({})
    end
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_aliases'
    end

    it 'performs the request' do
      expect(client_double.indices.get_aliases(index: 'foo^bar')).to eq({})
    end
  end
end
