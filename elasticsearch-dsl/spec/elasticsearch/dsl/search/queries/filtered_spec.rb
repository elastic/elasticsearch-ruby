require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Filtered do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(filtered: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:filtered][:query]).to eq('bar')
      end
    end

    describe '#filter' do

      before do
        search.filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:filtered][:filter]).to eq('bar')
      end
    end

    describe '#strategy' do

      before do
        search.strategy('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:filtered][:strategy]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query do
            match foo: 'BLAM'
          end
          filter do
            term bar: 'slam'
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(filtered: { query: { match: { foo: 'BLAM' } }, filter: { term: { bar: 'slam' } } })
      end
    end
  end
end
