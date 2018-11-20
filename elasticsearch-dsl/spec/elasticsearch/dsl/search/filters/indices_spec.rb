require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Indices do

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

    describe '#filter' do

      before do
        search.filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:filter]).to eq('bar')
      end
    end

    describe '#no_match_filter' do

      before do
        search.no_match_filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:no_match_filter]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          indices 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(indices: { indices: 'bar' })
      end
    end

    context 'when a block is provided to an option method' do

      let(:search) do
        described_class.new do
          indices 'bar'

          filter do
            term foo: 'bar'
          end
          no_match_filter do
            term foo: 'bam'
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(indices: { indices: 'bar', filter: { term: { foo: 'bar' } },
                                                no_match_filter: { term: { foo: 'bam' } } })
      end
    end
  end
end
