# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Boosting do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(boosting: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#positive' do

      before do
        search.positive('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:boosting][:positive]).to eq('bar')
      end
    end

    describe '#negative' do

      before do
        search.negative('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:boosting][:negative]).to eq('bar')
      end
    end

    describe '#negative_boost' do

      before do
        search.negative_boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:boosting][:negative_boost]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          positive foo: 'bar'
          negative moo: 'xoo'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:boosting][:positive][:foo]).to eq('bar')
        expect(search.to_hash[:boosting][:negative][:moo]).to eq('xoo')
      end
    end
  end
end
