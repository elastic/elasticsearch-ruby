require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::HasChild do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(has_child: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#type' do

      before do
        search.type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:foo][:type]).to eq('bar')
      end
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:query]).to eq('bar')
      end
    end

    describe '#filter' do

      before do
        search.filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:filter]).to eq('bar')
      end
    end

    describe '#min_children' do

      before do
        search.min_children('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:foo][:min_children]).to eq('bar')
      end
    end

    describe '#max_children' do

      before do
        search.max_children('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:foo][:max_children]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          type 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(has_child: { foo: { type: 'bar' } })
      end
    end

    context 'when a block is provided to an option method' do

      let(:search) do
        described_class.new do
          type 'bar'
          query do
            match :foo do
              query 'bar'
            end
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(has_child: { type: 'bar', query: { match: { foo: { query: 'bar'} } } })
      end
    end
  end
end
