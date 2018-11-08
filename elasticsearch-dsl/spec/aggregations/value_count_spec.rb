require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::ValueCount do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(value_count: {})
    end
  end

  context '#initialize' do

    let(:search) do
      described_class.new(foo: 'bar')
    end

    it 'sets the value' do
      expect(search.to_hash).to eq(value_count: { foo: 'bar' })
    end
  end
end
