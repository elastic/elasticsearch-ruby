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

describe Elasticsearch::DSL::Search::Aggregations::DateHistogram do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(date_histogram: {})
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
        expect(search.to_hash[:date_histogram][:foo][:field]).to eq('bar')
      end
    end

    describe '#interval' do

      before do
        search.interval('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:interval]).to eq('bar')
      end
    end

    describe '#pre_zone' do

      before do
        search.pre_zone('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:pre_zone]).to eq('bar')
      end
    end

    describe '#post_zone' do

      before do
        search.post_zone('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:post_zone]).to eq('bar')
      end
    end

    describe '#time_zone' do

      before do
        search.time_zone('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:time_zone]).to eq('bar')
      end
    end

    describe '#pre_zone_adjust_large_interval' do

      before do
        search.pre_zone_adjust_large_interval('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:pre_zone_adjust_large_interval]).to eq('bar')
      end
    end

    describe '#pre_offest' do

      before do
        search.pre_offset('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:pre_offset]).to eq('bar')
      end
    end

    describe '#post_offset' do

      before do
        search.post_offset('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:post_offset]).to eq('bar')
      end
    end

    describe '#format' do

      before do
        search.format('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:format]).to eq('bar')
      end
    end

    describe '#min_doc_count' do

      before do
        search.min_doc_count('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:min_doc_count]).to eq('bar')
      end
    end

    describe '#extended_bounds' do

      before do
        search.extended_bounds('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:extended_bounds]).to eq('bar')
      end
    end

    describe '#order' do

      before do
        search.order('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:date_histogram][:foo][:order]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field    'bar'
          interval 'day'
          format   'yyyy-MM-dd'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(date_histogram: { field: 'bar', interval: 'day', format: 'yyyy-MM-dd' })
      end
    end
  end
end
