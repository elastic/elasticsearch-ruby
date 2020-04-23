# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::GeoShape do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(geo_shape: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#shape' do

      before do
        search.shape('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_shape][:foo][:shape]).to eq('bar')
      end
    end

    describe '#indexed_shape' do

      before do
        search.indexed_shape('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_shape][:foo][:indexed_shape]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new :foo do
          shape 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geo_shape: { foo: { shape: 'bar' } })
      end
    end
  end
end
