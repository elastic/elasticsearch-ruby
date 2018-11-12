require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Not do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(not: {})
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(filters: [ { term: { foo: 'bar' } } ])
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(not: { filters: [ { term: { foo: 'bar' } } ] })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          term foo: 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(not: { term: { foo: 'bar' } })
      end
    end
  end
end
