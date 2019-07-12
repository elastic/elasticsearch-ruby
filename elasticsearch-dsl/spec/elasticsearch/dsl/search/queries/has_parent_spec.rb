# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::HasParent do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(has_parent: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#parent_type' do

      before do
        search.parent_type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:parent_type]).to eq('bar')
      end
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:query]).to eq('bar')
      end
    end

    describe '#score_mode' do

      before do
        search.score_mode('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:score_mode]).to eq('bar')
      end
    end

    describe '#inner_hits' do

      before do
        search.inner_hits(size: 1)
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:inner_hits]).to eq(size: 1)
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          parent_type 'bar'
          query match: { foo: 'bar' }
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(has_parent: { parent_type: 'bar', query: { match: { foo: 'bar' } } })
      end
    end
  end
end
