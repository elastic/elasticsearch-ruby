# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::GeohashGrid do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(geohash_grid: {})
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
        expect(search.to_hash[:geohash_grid][:foo][:field]).to eq('bar')
      end
    end

    describe '#precision' do

      before do
        search.precision('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geohash_grid][:foo][:precision]).to eq('bar')
      end
    end

    describe '#size' do

      before do
        search.size('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geohash_grid][:foo][:size]).to eq('bar')
      end
    end

    describe '#shard_size' do

      before do
        search.shard_size('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geohash_grid][:foo][:shard_size]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field 'bar'
          precision 5
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geohash_grid: { field: 'bar', precision: 5 })
      end
    end
  end
end
