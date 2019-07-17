# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::PercentilesBucket do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(percentiles_bucket: {})
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
        expect(search.to_hash[:percentiles_bucket][:foo][:buckets_path]).to eq('bar')
      end
    end

    describe '#gap_policy' do

      before do
        search.gap_policy('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:percentiles_bucket][:foo][:gap_policy]).to eq('bar')
      end
    end

    describe '#format' do

      before do
        search.format('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:percentiles_bucket][:foo][:format]).to eq('bar')
      end
    end

    describe '#percents' do

      before do
        search.percents([ 1, 5, 25, 50, 75, 95, 99 ])
      end

      it 'applies the option' do
        expect(search.to_hash[:percentiles_bucket][:foo][:percents]).to eq([ 1, 5, 25, 50, 75, 95, 99 ])
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
        expect(search.to_hash).to eq({ percentiles_bucket: { foo: { format: 'bar' } } })
      end
    end
  end
end
