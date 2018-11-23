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

describe Elasticsearch::DSL::Search::Aggregations::ScriptedMetric do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(scripted_metric: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#init_script' do

      before do
        search.init_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:init_script]).to eq('bar')
      end
    end

    describe '#map_script' do

      before do
        search.map_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:map_script]).to eq('bar')
      end
    end

    describe '#combine_script' do

      before do
        search.combine_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:combine_script]).to eq('bar')
      end
    end

    describe '#reduce_script' do

      before do
        search.reduce_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:reduce_script]).to eq('bar')
      end
    end

    describe '#params' do

      before do
        search.params('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:params]).to eq('bar')
      end
    end

    describe '#lang' do

      before do
        search.lang('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:lang]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          init_script 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(scripted_metric: { init_script: 'bar' })
      end
    end
  end
end
