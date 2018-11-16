require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::FuzzyLikeThisField do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(fuzzy_like_this_field: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#like_text' do

      before do
        search.like_text('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this_field][:like_text]).to eq('bar')
      end
    end

    describe '#fuzziness' do

      before do
        search.fuzziness('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this_field][:fuzziness]).to eq('bar')
      end
    end

    describe '#analyzer' do

      before do
        search.analyzer('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this_field][:analyzer]).to eq('bar')
      end
    end

    describe '#max_query_terms' do

      before do
        search.max_query_terms('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this_field][:max_query_terms]).to eq('bar')
      end
    end

    describe '#prefix_length' do

      before do
        search.prefix_length('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this_field][:prefix_length]).to eq('bar')
      end
    end

    describe '#boost' do

      before do
        search.boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this_field][:boost]).to eq('bar')
      end
    end

    describe '#ignore_tf' do

      before do
        search.ignore_tf('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this_field][:ignore_tf]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          like_text 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:fuzzy_like_this_field][:like_text]).to eq('bar')
      end
    end
  end
end
