require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Nested do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(nested: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#path' do

      before do
        search.path('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:nested][:path]).to eq('bar')
      end
    end

    describe '#filter' do

      before do
        search.filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:nested][:filter]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          path 'bar'
          filter do
            term foo: 'bar'
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(nested: { path: 'bar', filter: { term: { foo: 'bar' } } })
      end
    end
  end
end
