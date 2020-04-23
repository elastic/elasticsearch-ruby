# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::IpRange do

  let(:search) do
    described_class.new
  end

  context '#initialize' do

    let(:search) do
      described_class.new(foo: 'bar')
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(ip_range: { foo: 'bar' })
    end

    context 'when args are passed' do

      let(:search) do
        described_class.new(field: 'test', ranges: [ {to: 'foo'}, {from: 'bar'} ])
      end

      it 'defines filters' do
        expect(search.to_hash).to eq(ip_range: { field: 'test', ranges: [ {to: 'foo'}, {from: 'bar'} ] })
      end
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#field' do

      before do
        search.field('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:ip_range][:foo][:field]).to eq('bar')
      end
    end

    describe '#ranges' do

      before do
        search.ranges('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:ip_range][:foo][:ranges]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          field 'bar'
          ranges [ {to: 'foo'}, {from: 'bar'} ]
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(ip_range: { field: 'bar', ranges: [ {to: 'foo'}, {from: 'bar'} ] })
      end
    end
  end
end
