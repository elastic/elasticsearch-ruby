require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::MoreLikeThis do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(more_like_this: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'fields',
      'like_text',
      'min_term_freq',
      'max_query_terms',
      'docs',
      'ids',
      'include',
      'exclude',
      'percent_terms_to_match',
      'stop_words',
      'min_doc_freq',
      'max_doc_freq',
      'min_word_length',
      'max_word_length',
      'boost_terms',
      'boost',
      'analyzer' ].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:more_like_this][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          fields ['foo', 'bar']
          like_text 'abc'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:more_like_this][:fields]).to eq(['foo', 'bar'])
        expect(search.to_hash[:more_like_this][:like_text]).to eq('abc')
      end
    end
  end
end
