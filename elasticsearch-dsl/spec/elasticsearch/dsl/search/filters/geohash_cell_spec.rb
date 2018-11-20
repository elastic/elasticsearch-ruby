require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::GeohashCell do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(geohash_cell: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#precision' do

      before do
        search.precision('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geohash_cell][:precision]).to eq('bar')
      end
    end

    describe '#neighbors' do

      before do
        search.neighbors('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geohash_cell][:neighbors]).to eq('bar')
      end
    end

    describe '#lat' do

      before do
        search.lat('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geohash_cell][:foo][:lat]).to eq('bar')
      end
    end

    describe '#lon' do

      before do
        search.lon('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geohash_cell][:foo][:lon]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new :foo do
          lat 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geohash_cell: { foo: { lat: 'bar' } })
      end
    end
  end
end
