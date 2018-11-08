require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::GeoBounds do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(geo_bounds: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#field' do

      before do
        search.field('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounds][:foo][:field]).to eq('bar')
      end
    end

    describe '#wrap_longitude' do

      before do
        search.wrap_longitude('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounds][:foo][:wrap_longitude]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geo_bounds: { field: 'bar' })
      end
    end
  end
end
