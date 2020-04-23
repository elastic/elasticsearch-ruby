# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Fuzzy do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(fuzzy: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#value' do

      before do
        search.value('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy][:value]).to eq('bar')
      end
    end

    describe '#boost' do

      before do
        search.boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy][:boost]).to eq('bar')
      end
    end

    describe '#fuzziness' do

      before do
        search.fuzziness('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy][:fuzziness]).to eq('bar')
      end
    end

    describe '#prefix_length' do

      before do
        search.prefix_length('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy][:prefix_length]).to eq('bar')
      end
    end

    describe '#max_expansions' do

      before do
        search.max_expansions('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy][:max_expansions]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          value 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:fuzzy][:value]).to eq('bar')
      end
    end
  end
end
