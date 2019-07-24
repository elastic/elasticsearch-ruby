# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::SignificantText do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(significant_text: {})
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
        expect(search.to_hash[:significant_text][:foo][:field]).to eq('bar')
      end
    end

    describe '#size' do

      before do
        search.size('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:size]).to eq('bar')
      end
    end

    describe '#shard_size' do

      before do
        search.shard_size('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:shard_size]).to eq('bar')
      end
    end

    describe '#min_doc_count' do

      before do
        search.min_doc_count('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:min_doc_count]).to eq('bar')
      end
    end

    describe '#shard_min_doc_count' do

      before do
        search.shard_min_doc_count('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:shard_min_doc_count]).to eq('bar')
      end
    end

    describe '#include' do

      before do
        search.include('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:include]).to eq('bar')
      end
    end

    describe '#exclude' do

      before do
        search.exclude('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:exclude]).to eq('bar')
      end
    end

    describe '#background_filter' do

      before do
        search.background_filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:background_filter]).to eq('bar')
      end
    end

    describe '#mutual_information' do

      before do
        search.mutual_information('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:mutual_information]).to eq('bar')
      end
    end

    describe '#chi_square' do

      before do
        search.chi_square('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:chi_square]).to eq('bar')
      end
    end

    describe '#gnd' do

      before do
        search.gnd('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:significant_text][:foo][:gnd]).to eq('bar')
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
        expect(search.to_hash).to eq(significant_text: { field: 'bar' })
      end
    end
  end
end
