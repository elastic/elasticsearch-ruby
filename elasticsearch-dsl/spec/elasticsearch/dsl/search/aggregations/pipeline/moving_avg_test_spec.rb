require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::MovingAvg do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(moving_avg: {})
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
        expect(search.to_hash[:moving_avg][:foo][:buckets_path]).to eq('bar')
      end
    end

    describe '#gap_policy' do

      before do
        search.gap_policy('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:gap_policy]).to eq('bar')
      end
    end

    describe '#minimize' do

      before do
        search.minimize(false)
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:minimize]).to eq(false)
      end
    end

    describe '#model' do

      before do
        search.model('simple')
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:model]).to eq('simple')
      end
    end

    describe '#settings' do

      before do
        search.settings(period: 7)
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:settings]).to eq(period: 7)
      end
    end

    describe '#window' do

      before do
        search.window(5)
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:window]).to eq(5)
      end
    end

    describe '#format' do

      before do
        search.format('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:format]).to eq('bar')
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
        expect(search.to_hash).to eq({ moving_avg: { foo: { format: 'bar' } } })
      end
    end
  end
end
