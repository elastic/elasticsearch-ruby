require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::BucketScript do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(bucket_script: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#buckets_path' do

      before do
        search.buckets_path('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_script][:foo][:buckets_path]).to eq('bar')
      end
    end

    describe '#script' do

      before do
        search.script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_script][:foo][:script]).to eq('bar')
      end
    end

    describe '#gap_policy' do

      before do
        search.gap_policy('skip')
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_script][:foo][:gap_policy]).to eq('skip')
      end
    end

    describe '#format' do

      before do
        search.format('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_script][:foo][:format]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          format 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq({ bucket_script: { foo: { format: 'bar' } } })
      end
    end
  end
end
