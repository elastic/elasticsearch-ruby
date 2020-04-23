# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Template do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(template: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'query',
      'params' ].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:template][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(query: 'bar', params: { foo: 'abc' })
      end

      it 'sets the value' do
        expect(search.to_hash[:template][:query]).to eq('bar')
        expect(search.to_hash[:template][:params][:foo]).to eq('abc')
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query 'bar'
          params foo: 'abc'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:template][:query]).to eq('bar')
        expect(search.to_hash[:template][:params][:foo]).to eq('abc')
      end
    end
  end
end
