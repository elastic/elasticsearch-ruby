# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::DisMax do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(dis_max: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#tie_breaker' do

      before do
        search.tie_breaker('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:dis_max][:tie_breaker]).to eq('bar')
      end
    end

    describe '#boost' do

      before do
        search.boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:dis_max][:boost]).to eq('bar')
      end
    end

    describe '#queries' do

      before do
        search.queries('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:dis_max][:queries]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          tie_breaker 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:dis_max][:tie_breaker]).to eq('bar')
      end
    end
  end
end
