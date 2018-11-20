require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Script do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(script: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#script' do

      before do
        search.script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:script][:foo][:script]).to eq('bar')
      end
    end

    describe '#params' do

      before do
        search.params(foo: 'bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:script][:foo][:params]).to eq(foo: 'bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          script 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(script: { foo: { script: 'bar' } })
      end
    end
  end
end
