require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Min do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(min: {})
    end
  end

  context '#initialize' do

    let(:search) do
      described_class.new(foo: 'bar')
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(min: { foo: 'bar' })
    end
  end
end
