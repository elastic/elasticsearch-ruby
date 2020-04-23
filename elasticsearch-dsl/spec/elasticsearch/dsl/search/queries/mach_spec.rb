# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Match do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(match: {})
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
        expect(search.to_hash[:match][:query]).to eq('bar')
      end
    end

    describe '#operator' do

      before do
        search.operator('standard')
      end

      it 'applies the option' do
        expect(search.to_hash[:match][:operator]).to eq('standard')
      end
    end

    describe '#type' do

      before do
        search.type(10)
      end

      it 'applies the option' do
        expect(search.to_hash[:match][:type]).to eq(10)
      end
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(message: { query: 'test' })
      end

      it 'sets the value' do
        expect(search.to_hash).to eq(match: { message: { query: 'test' } })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query     'test'
          operator  'and'
          type      'phrase_prefix'
          boost     2
          fuzziness 'AUTO'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:match][:query]).to eq('test')
        expect(search.to_hash[:match][:operator]).to eq('and')
        expect(search.to_hash[:match][:type]).to eq('phrase_prefix')
        expect(search.to_hash[:match][:boost]).to eq(2)
        expect(search.to_hash[:match][:fuzziness]).to eq('AUTO')
      end
    end
  end
end
