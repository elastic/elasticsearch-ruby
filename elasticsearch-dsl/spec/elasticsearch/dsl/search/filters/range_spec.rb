# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Range do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(range: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#gte' do

      before do
        search.gte('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:range][:foo][:gte]).to eq('bar')
      end
    end

    describe '#lte' do

      before do
        search.lte('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:range][:foo][:lte]).to eq('bar')
      end
    end

    describe '#time_zone' do

      before do
        search.time_zone('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:range][:foo][:time_zone]).to eq('bar')
      end
    end

    describe '#format' do

      before do
        search.format('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:range][:foo][:format]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(age: { gte: 10, lte: 20 })
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(range: { age: { gte: 10, lte: 20 } })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:age) do
          gte 10
          lte 20
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(range: { age: { gte: 10, lte: 20 } })
      end
    end
  end
end
