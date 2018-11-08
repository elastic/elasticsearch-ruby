require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::TopHits do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(top_hits: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#from' do

      before do
        search.from('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:top_hits][:foo][:from]).to eq('bar')
      end
    end

    describe '#size' do

      before do
        search.size('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:top_hits][:foo][:size]).to eq('bar')
      end
    end

    describe '#sort' do

      before do
        search.sort('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:top_hits][:foo][:sort]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          from 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(top_hits: { from: 'bar' })
      end
    end
  end
end
