require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::MatchAll do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(match_all: {})
    end
  end
end
