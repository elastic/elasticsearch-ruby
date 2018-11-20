require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Prefix do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(prefix: {})
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(foo: 'bar')
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(prefix: { foo: 'bar' })
      end
    end
  end
end
