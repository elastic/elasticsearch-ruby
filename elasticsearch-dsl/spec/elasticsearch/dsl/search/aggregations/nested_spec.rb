# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Nested do

  let(:search) do
    described_class.new
  end

  context '#initialize' do

    let(:search) do
      described_class.new(path: 'bar')
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(nested: { path: 'bar' })
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#path' do

      before do
        search.path('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:nested][:foo][:path]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          path 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(nested: { path: 'bar' })
      end
    end

    context 'when another aggregation is nested' do

      let(:search) do
        described_class.new do
          path 'bar'
          aggregation :min_price do
            min field: 'bam'
          end
        end
      end

      it 'nests the aggregation in the hash' do
        expect(search.to_hash).to eq(nested: { path: 'bar' }, aggregations: { min_price: { min: { field: 'bam' } } })
      end
    end
  end
end
