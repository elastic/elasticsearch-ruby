# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Filter do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(filter: {})
    end
  end

  context 'when another aggregation is nested' do

    let(:search) do
      described_class.new(terms: { foo: 'bar' }) do
        aggregation :sum_clicks do
          sum moo: 'bam'
        end
      end
    end

    it 'nests the aggregation in the hash' do
      expect(search.to_hash).to eq(filter: { terms: { foo: 'bar' } },
                                   aggregations: { sum_clicks: { sum: { moo: 'bam' } } })
    end
  end
end
