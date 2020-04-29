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

describe Elasticsearch::DSL::Search::Queries::Common do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(common: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:common][:query]).to eq('bar')
      end
    end

    describe '#cutoff_frequency' do

      before do
        search.cutoff_frequency('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:common][:cutoff_frequency]).to eq('bar')
      end
    end

    describe '#low_freq_operator' do

      before do
        search.low_freq_operator('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:common][:low_freq_operator]).to eq('bar')
      end
    end

    describe '#minimum_should_match' do

      before do
        search.minimum_should_match('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:common][:minimum_should_match]).to eq('bar')
      end
    end

    describe '#boost' do

      before do
        search.boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:common][:boost]).to eq('bar')
      end
    end

    describe '#analyzer' do

      before do
        search.analyzer('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:common][:analyzer]).to eq('bar')
      end
    end

    describe '#disable_coord' do

      before do
        search.disable_coord('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:common][:disable_coord]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:common][:query]).to eq('bar')
      end
    end
  end
end
