# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Ids do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(ids: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#type' do

      before do
        search.type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:ids][:type]).to eq('bar')
      end
    end

    describe '#values' do

      before do
        search.values('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:ids][:values]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          type 'bar'
          values [1, 2, 3]
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(ids: { type: 'bar', values: [1, 2, 3] })
      end
    end
  end
end
