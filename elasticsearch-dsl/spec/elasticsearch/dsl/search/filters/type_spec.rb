# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Type do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(type: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#value' do

      before do
        search.value('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:type][:foo][:value]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          value 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(type: { foo: { value: 'bar' } })
      end
    end
  end
end
