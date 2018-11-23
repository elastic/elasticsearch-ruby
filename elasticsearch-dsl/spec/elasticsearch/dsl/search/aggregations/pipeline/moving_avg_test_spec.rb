# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::MovingAvg do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(moving_avg: {})
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
        expect(search.to_hash[:moving_avg][:foo][:buckets_path]).to eq('bar')
      end
    end

    describe '#gap_policy' do

      before do
        search.gap_policy('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:gap_policy]).to eq('bar')
      end
    end

    describe '#minimize' do

      before do
        search.minimize(false)
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:minimize]).to eq(false)
      end
    end

    describe '#model' do

      before do
        search.model('simple')
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:model]).to eq('simple')
      end
    end

    describe '#settings' do

      before do
        search.settings(period: 7)
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:settings]).to eq(period: 7)
      end
    end

    describe '#window' do

      before do
        search.window(5)
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:window]).to eq(5)
      end
    end

    describe '#format' do

      before do
        search.format('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:moving_avg][:foo][:format]).to eq('bar')
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
        expect(search.to_hash).to eq({ moving_avg: { foo: { format: 'bar' } } })
      end
    end
  end
end
