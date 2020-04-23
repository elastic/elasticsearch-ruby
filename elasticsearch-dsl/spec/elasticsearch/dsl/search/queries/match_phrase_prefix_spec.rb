# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::MatchPhrasePrefix do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(match_phrase_prefix: {})
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
        expect(search.to_hash[:match_phrase_prefix][:query]).to eq('bar')
      end
    end

    describe '#boost' do

      before do
        search.boost(10)
      end

      it 'applies the option' do
        expect(search.to_hash[:match_phrase_prefix][:boost]).to eq(10)
      end
    end

    describe '#max_expansions' do

      before do
        search.max_expansions(2)
      end

      it 'applies the option' do
        expect(search.to_hash[:match_phrase_prefix][:max_expansions]).to eq(2)
      end
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(message: 'test')
      end

      it 'sets the value' do
        expect(search.to_hash).to eq(match_phrase_prefix: { message: 'test' })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query          'test'
          boost          2
          max_expansions 1
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:match_phrase_prefix][:query]).to eq('test')
        expect(search.to_hash[:match_phrase_prefix][:boost]).to eq(2)
        expect(search.to_hash[:match_phrase_prefix][:max_expansions]).to eq(1)
      end
    end
  end
end
