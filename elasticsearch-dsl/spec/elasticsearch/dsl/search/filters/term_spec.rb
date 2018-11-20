require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Term do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(term: {})
    end
  end

  describe '#initialize' do

    context 'when a scalar is specified' do

      let(:search) do
        described_class.new(message: 'test')
      end

      it 'sets the value' do
        expect(search.to_hash).to eq(term: { message: 'test' })
      end
    end

    context 'when a hash is specified' do

      let(:search) do
        described_class.new(message: { query: 'test' })
      end

      it 'sets the value' do
        expect(search.to_hash).to eq(term: { message: { query: 'test' } })
      end
    end
  end
end
