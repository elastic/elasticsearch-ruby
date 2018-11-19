require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Term do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(term: {})
    end
  end

  describe '#initialize' do

    context 'when a String is provided' do

      let(:search) do
        described_class.new(message: 'test')
      end

      it 'executes the block' do
        expect(search.to_hash[:term][:message]).to eq('test')
      end
    end

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(message: { query: 'test', boost: 2 })
      end

      it 'sets the value' do
        expect(search.to_hash[:term][:message]).to eq(query: 'test', boost: 2)
      end
    end
  end
end
