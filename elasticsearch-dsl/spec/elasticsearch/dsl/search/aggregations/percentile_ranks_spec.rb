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

describe Elasticsearch::DSL::Search::Aggregations::PercentileRanks do

  let(:search) do
    described_class.new
  end

  context '#initialize' do

    let(:search) do
      described_class.new(foo: 'bar')
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(percentile_ranks: { foo: 'bar' })
    end

    context 'when args are passed' do

      let(:search) do
        described_class.new(field: 'test')
      end

      it 'defines filters' do
        expect(search.to_hash).to eq(percentile_ranks: { field: 'test' })
      end
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
        expect(search.to_hash[:percentile_ranks][:foo][:field]).to eq('bar')
      end
    end

    describe '#values' do

      before do
        search.values('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:percentile_ranks][:foo][:values]).to eq('bar')
      end
    end

    describe '#script' do

      before do
        search.script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:percentile_ranks][:foo][:script]).to eq('bar')
      end
    end

    describe '#params' do

      before do
        search.params('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:percentile_ranks][:foo][:params]).to eq('bar')
      end
    end

    describe '#compression' do

      before do
        search.compression('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:percentile_ranks][:foo][:compression]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field 'bar'
          values [5, 10]
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(percentile_ranks: { field: 'bar', values: [5, 10] })
      end
    end
  end
end
