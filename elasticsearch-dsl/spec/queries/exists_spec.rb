require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Exists do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(exists: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#field' do

      before do
        search.field('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:exists][:field]).to eq('bar')
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
        expect(search.to_hash[:exists][:field]).to eq('bar')
      end
    end
  end
end
