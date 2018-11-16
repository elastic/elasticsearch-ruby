require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::SimpleQueryString do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(simple_query_string: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'query',
      'fields',
      'default_operator',
      'analyzer',
      'flags',
      'lenient'].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:simple_query_string][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          query 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:simple_query_string][:foo][:query]).to eq('bar')
      end
    end
  end
end
