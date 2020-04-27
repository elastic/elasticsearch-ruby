# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::HasChild do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(has_child: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#type' do

      before do
        search.type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:type]).to eq('bar')
      end
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:query]).to eq('bar')
      end
    end

    describe '#score_mode' do

      before do
        search.score_mode('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:score_mode]).to eq('bar')
      end
    end

    describe '#min_children' do

      before do
        search.min_children('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:min_children]).to eq('bar')
      end
    end

    describe '#max_children' do

      before do
        search.max_children('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_child][:max_children]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          type 'bar'
          query do
            match :foo do
              query 'bar'
            end
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(has_child: { type: 'bar', query: { match: { foo: { query: 'bar'} } } })
      end
    end
  end
end
