require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Children do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(children: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#type' do

      before do
        search.type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:children][:foo][:type]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          type 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq({ children: { foo: { type: 'bar' } } })
      end
    end
  end
end
