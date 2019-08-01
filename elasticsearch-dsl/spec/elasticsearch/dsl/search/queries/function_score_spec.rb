# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::FunctionScore do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(function_score: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:query]).to eq('bar')
      end
    end

    describe '#filter' do

      before do
        search.filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:filter]).to eq('bar')
      end
    end

    describe '#functions' do

      before do
        search.functions('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:functions]).to eq('bar')
      end

      context 'when the option is called as a setter' do

        before do
          search.functions = [ {foo: { abc: '123' }} ]
        end

        it 'applies the option' do
          expect(search.to_hash).to eq(function_score: { functions: [ {foo: { abc: '123' }} ] })
        end
      end
    end

    describe '#script_score' do

      before do
        search.script_score('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:script_score]).to eq('bar')
      end
    end

    describe '#boost' do

      before do
        search.boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:boost]).to eq('bar')
      end
    end

    describe '#max_boost' do

      before do
        search.max_boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:max_boost]).to eq('bar')
      end
    end

    describe '#score_mode' do

      before do
        search.score_mode('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:score_mode]).to eq('bar')
      end
    end

    describe '#boost_mode' do

      before do
        search.boost_mode('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:boost_mode]).to eq('bar')
      end
    end

    describe '#min_scoore' do

      before do
        search.min_score('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:function_score][:min_score]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query do
            match foo: 'BLAM'
          end
          filter do
            term bar: 'slam'
          end
          functions << { foo: { abc: '123' } }
          functions << { foo: { xyz: '456' } }
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(function_score: {
            query: { match: { foo: 'BLAM' } },
            filter: { term: { bar: 'slam' } },
            functions: [ { foo: { abc: '123' } }, { foo: { xyz: '456' } } ] })
      end
    end
  end
end
