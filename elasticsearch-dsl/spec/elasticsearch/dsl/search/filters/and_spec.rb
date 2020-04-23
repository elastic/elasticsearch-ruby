# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::And do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(and: {})
    end
  end

  context 'when enumerable methods are called' do

    before do
      search << { term: { foo: 'bar' } }
      search << { term: { moo: 'mam' } }
    end

    it 'behaves like an enumerable' do
      expect(search.size).to eq(2)
      expect(search[0][:term][:foo]).to eq('bar')
      expect(search.any? { |d| d[:term] == { foo: 'bar' } }).to be(true)
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(filters: [ { term: { foo: 'bar' } } ])
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(and: { filters: [ { term: { foo: 'bar' } } ] })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          term foo: 'bar'
          term moo: 'mam'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(and: [ { term: { foo: 'bar' } }, { term: { moo: 'mam' } } ])
      end
    end
  end
end
