require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Or do

  let(:search) do
    described_class.new
  end

  it 'responds to enumerable methods' do
    expect(search.empty?).to be(true)
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(or: {})
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(filters: [ { term: { foo: 'bar' } } ])
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(or: { filters: [ { term: { foo: 'bar' } } ] })
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
        expect(search.to_hash).to eq(or: [ {term: { foo: 'bar'}}, {term: { moo: 'mam'}} ])
      end
    end
  end

  context 'when the filter is appended to' do

    before do
      search << { term: { foo: 'bar' } }
    end

    it 'appends the predicate' do
      expect(search.to_hash).to eq(or: [ { term: { foo: 'bar' } } ])
    end
  end
end
