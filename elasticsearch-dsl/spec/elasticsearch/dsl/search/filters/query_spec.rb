require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Query do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(query: {})
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(query_string: { query: 'foo' })
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(query: { query_string: { query: 'foo' } })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          match foo: 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(query: { match: { foo: 'bar' } })
      end
    end
  end
end
