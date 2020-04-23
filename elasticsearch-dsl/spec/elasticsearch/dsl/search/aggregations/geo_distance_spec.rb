# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::GeoDistance do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(geo_distance: {})
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
        expect(search.to_hash[:geo_distance][:foo][:field]).to eq('bar')
      end
    end

    describe '#origin' do

      before do
        search.origin('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:foo][:origin]).to eq('bar')
      end
    end

    describe '#ranges' do

      before do
        search.ranges('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:foo][:ranges]).to eq('bar')
      end
    end

    describe '#unit' do

      before do
        search.unit('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:foo][:unit]).to eq('bar')
      end
    end

    describe '#distance_type' do

      before do
        search.distance_type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:foo][:distance_type]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field 'bar'
          origin lat: 50, lon: 5
          ranges [ { to: 50 }, { from: 50, to: 100 }, { from: 100 } ]
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geo_distance: { field: 'bar', origin: { lat: 50, lon: 5 },
                                                     ranges: [ { to: 50 }, { from: 50, to: 100 }, { from: 100 } ] })
      end
    end
  end
end
