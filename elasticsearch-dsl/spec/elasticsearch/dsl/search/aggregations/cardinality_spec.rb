# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Cardinality do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(cardinality: {})
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
        expect(search.to_hash[:cardinality][:foo][:field]).to eq('bar')
      end
    end

    describe '#precision_threshold' do

      before do
        search.precision_threshold('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:cardinality][:foo][:precision_threshold]).to eq('bar')
      end
    end

    describe '#rehash' do

      before do
        search.rehash('skip')
      end

      it 'applies the option' do
        expect(search.to_hash[:cardinality][:foo][:rehash]).to eq('skip')
      end
    end

    describe '#script' do

      before do
        search.script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:cardinality][:foo][:script]).to eq('bar')
      end
    end

    describe '#params' do

      before do
        search.params('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:cardinality][:foo][:params]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          field 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq({ cardinality: { foo: { field: 'bar' } } })
      end
    end
  end
end
