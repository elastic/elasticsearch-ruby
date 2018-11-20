require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::ReverseNested do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(reverse_nested: {})
    end
  end
end
