# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Range do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(range: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'gte',
      'lte',
      'boost',
      'format'].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:range][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          gte   10
          lte   20
          boost 2
          format 'mm/dd/yyyy'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:range][:gte]).to eq(10)
        expect(search.to_hash[:range][:lte]).to eq(20)
        expect(search.to_hash[:range][:boost]).to eq(2)
        expect(search.to_hash[:range][:format]).to eq('mm/dd/yyyy')
      end
    end
  end
end
