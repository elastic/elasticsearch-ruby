# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Wildcard do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(wildcard: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'value',
      'boost' ].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:wildcard][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(foo: 'bar')
      end

      it 'sets the value' do
        expect(search.to_hash[:wildcard][:foo]).to eq('bar')
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          value 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:wildcard][:value]).to eq('bar')
      end
    end
  end
end
