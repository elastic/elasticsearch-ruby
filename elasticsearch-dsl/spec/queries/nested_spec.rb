require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Nested do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(nested: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'path',
      'score_mode',
      'score_mode',
      'query' ].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:nested][option.to_sym]).to eq('bar')
        end
      end

      describe '#inner_hits' do

        before do
          search.inner_hits(size: 1)
        end

        it 'applies the option' do
          expect(search.to_hash[:nested][:inner_hits]).to eq(size: 1)
        end
      end

      describe '#query' do

        before do
          search.query(match: { foo: 'bar' })
        end

        it 'applies the option' do
          expect(search.to_hash[:nested][:query]).to eq(match: { foo: 'bar' })
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          path 'bar'
          query do
            match foo: 'bar'
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:nested][:path]).to eq('bar')
        expect(search.to_hash[:nested][:query]).to eq(match: { foo: 'bar' })
      end
    end
  end
end
