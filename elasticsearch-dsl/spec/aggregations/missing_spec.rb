require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Missing do

  let(:search) do
    described_class.new
  end

  context '#initialize' do

    let(:search) do
      described_class.new(foo: 'bar')
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(missing: { foo: 'bar' })
    end

    context 'when args are passed' do

      let(:search) do
        described_class.new(field: 'test')
      end

      it 'defines filters' do
        expect(search.to_hash).to eq(missing: { field: 'test' })
      end
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#field' do

      before do
        search.field('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:missing][:foo][:field]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(missing: { field: 'bar' })
      end
    end
  end
end
