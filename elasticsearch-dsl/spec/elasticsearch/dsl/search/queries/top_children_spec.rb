# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::TopChildren do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(top_children: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'type',
      'query',
      'score',
      'factor',
      'incremental_factor',
      '_scope' ].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:top_children][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          type 'bar'
          query 'foo'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:top_children][:type]).to eq('bar')
        expect(search.to_hash[:top_children][:query]).to eq('foo')
      end
    end

    context 'when nested blocks are provided' do

      let(:search) do
        described_class.new do
          type 'bar'
          query do
            match foo: 'BLAM'
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:top_children][:type]).to eq('bar')
        expect(search.to_hash[:top_children][:query][:match][:foo]).to eq('BLAM')
      end
    end
  end
end
