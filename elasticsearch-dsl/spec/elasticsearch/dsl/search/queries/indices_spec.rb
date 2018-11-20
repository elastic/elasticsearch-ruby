require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Indices do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(indices: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#indices' do

      before do
        search.indices('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:indices]).to eq('bar')
      end
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:query]).to eq('bar')
      end
    end

    describe '#no_match_query' do

      before do
        search.no_match_query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:no_match_query]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          indices 'bar'
          query term: { foo: 'bar' }
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(indices: { indices: 'bar', query: { term: { foo: 'bar' } } } )
      end
    end
  end
end
