# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Global do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(global: {})
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(global: {})
      end
    end

    context 'when another aggregation is nested' do

      let(:search) do
        described_class.new do
          aggregation :foo do
            terms field: "bar"
          end
        end
      end

      it 'nests the aggregation in the hash' do
        expect(search.to_hash).to eq(aggregations: { foo: { terms: { field: "bar" } } }, global: {})
      end
    end
  end
end
