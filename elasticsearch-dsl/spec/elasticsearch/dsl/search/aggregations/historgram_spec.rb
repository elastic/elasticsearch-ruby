# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Histogram do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(histogram: {})
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
        expect(search.to_hash[:histogram][:foo][:field]).to eq('bar')
      end
    end

    describe '#interval' do

      before do
        search.interval('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:histogram][:foo][:interval]).to eq('bar')
      end
    end

    describe '#min_doc_count' do

      before do
        search.min_doc_count('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:histogram][:foo][:min_doc_count]).to eq('bar')
      end
    end

    describe '#extended_bounds' do

      before do
        search.extended_bounds('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:histogram][:foo][:extended_bounds]).to eq('bar')
      end
    end

    describe '#order' do

      before do
        search.order('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:histogram][:foo][:order]).to eq('bar')
      end
    end

    describe '#keyed' do

      before do
        search.keyed('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:histogram][:foo][:keyed]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field 'bar'
          interval 5
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(histogram: { field: 'bar', interval: 5 })
      end
    end
  end
end
