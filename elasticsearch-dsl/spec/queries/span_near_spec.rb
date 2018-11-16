require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::SpanNear do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(span_near: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'span_near',
      'slop',
      'in_order',
      'collect_payloads' ].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:span_near][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          span_near 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:span_near][:span_near]).to eq('bar')
      end
    end
  end
end
