# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Filters do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(filters: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#filters' do

      before do
        search.filters(foo: 'bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:filters][:filters][:foo]).to eq('bar')
      end
    end
  end

  context '#initialize' do

    let(:search) do
      described_class.new(foo: 'bar')
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(filters: { foo: 'bar' })
    end

    context 'when filters are passed' do

      let(:search) do
        described_class.new(filters: { foo: 'bar' })
      end

      it 'defines filters' do
        expect(search.to_hash).to eq(filters: { filters: { foo: 'bar' } })
      end
    end
  end

  context 'when another aggregation is nested' do

    let(:search) do
      described_class.new do
        filters foo: { terms: { foo: 'bar' } }
        aggregation :sum_clicks do
          sum moo: 'bam'
        end
      end
    end

    it 'nests the aggregation in the hash' do
      expect(search.to_hash).to eq(filters: { filters: { foo: { terms: { foo: 'bar' } } } },
                                   aggregations: { sum_clicks: { sum: { moo: 'bam' } } })
    end
  end
end
