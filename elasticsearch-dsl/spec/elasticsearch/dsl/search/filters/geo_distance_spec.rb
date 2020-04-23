# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::GeoDistance do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(geo_distance: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#distance' do

      before do
        search.distance('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:distance]).to eq('bar')
      end
    end

    describe '#distance_type' do

      before do
        search.distance_type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:distance_type]).to eq('bar')
      end
    end

    describe '#lat' do

      before do
        search.lat('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:foo][:lat]).to eq('bar')
      end
    end

    describe '#lon' do

      before do
        search.lon('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_distance][:foo][:lon]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new :foo do
          distance '1km'
          lat 40
          lon -70
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geo_distance: { distance: '1km', foo: { lat: 40, lon: -70 } })
      end

      context 'when options are also provided' do

        let(:search) do
          described_class.new(:foo, distance: '10km') do
            lat 40
            lon -70
          end
        end

        it 'executes the block' do
          expect(search.to_hash).to eq(geo_distance: { foo: { lat: 40, lon: -70 }, distance: '10km' })
        end
      end
    end

    context 'when options are provided' do

      let(:search) do
        described_class.new(distance: '10km', foo: { lat: 40, lon: -70 })
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geo_distance: { foo: { lat: 40, lon: -70 }, distance: '10km' })
      end
    end
  end
end
