# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Queries::Bool do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(bool: {})
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          must { match foo: 'bar' }
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(bool: {must: [ {match: { foo: 'bar' }} ] })
      end

      context 'when multiple option methods are called' do

        let(:search) do
          described_class.new do
            should   { term tag: 'wow' }
            should   { term tag: 'elasticsearch' }

            minimum_should_match 1
            boost 1.0
          end
        end

        it 'defines all the options' do
          expect(search.to_hash).to eq(bool: {
                                               minimum_should_match: 1,
                                               boost: 1.0,
                                               should:     [ {term: { tag: 'wow' }}, {term: { tag: 'elasticsearch' }} ]})
        end
      end

      context 'when multiple conditions are provided' do

        let(:search) do
          described_class.new do
            must do
              match foo: 'bar'
            end

            must do
              match moo: 'bam'
            end

            should do
              match xoo: 'bax'
            end

            should do
              match zoo: 'baz'
            end
          end
        end

        it 'applies each condition' do
          expect(search.to_hash).to eq(bool:
                                           { must:     [ {match: { foo: 'bar' }}, {match: { moo: 'bam' }} ],
                                             should:   [ {match: { xoo: 'bax' }}, {match: { zoo: 'baz' }} ]
                                           })
        end

        context 'when #to_hash is called more than once' do

          it 'does not alter the hash' do
            expect(search.to_hash).to eq(search.to_hash)
          end
        end
      end
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    before do
      search.must { match foo: 'bar' }
      search.must { match moo: 'bam' }
      search.should { match xoo: 'bax' }
    end

    it 'applies the option' do
      expect(search.to_hash).to eq(bool: { must:   [ {match: { foo: 'bar' }}, {match: { moo: 'bam' }} ],
                                           should: [ {match: { xoo: 'bax' }} ] })
    end
  end

  context 'when the filter method is called multiple times' do

    let(:search) do
      described_class.new
    end

    before do
      search.filter { term foo: 'bar' }
      search.filter { term zoo: 'baz' }
    end

    it 'combines the filter clauses' do
      expect(search.to_hash).to eq(bool:
                                       { filter: [
                                           { term: { foo: "bar"}},
                                           { term: { zoo: "baz"}}
                                       ] })
    end
  end

  context 'when methods are chained' do

    let(:search) do
      described_class.new
    end

    before do
      search.must { match foo: 'bar' }.must { match moo: 'bam' }.should { match xoo: 'bax' }
    end

    it 'applies the option' do
      expect(search.to_hash).to eq(bool: { must:   [ {match: { foo: 'bar' }}, {match: { moo: 'bam' }} ],
                                           should: [ {match: { xoo: 'bax' }} ] })
    end
  end

  describe '#filter' do

    context 'when a block is used to define the filter' do

      let(:search) do
        described_class.new do
          filter do
            term foo: 'Foo!'
          end
        end
      end

      it 'applies the filter' do
        expect(search.to_hash).to eq(bool: { filter: [{ term: { foo: 'Foo!' } }] })
      end
    end

    context 'when a filter is passed as an argument' do

      context 'when the filter is a hash' do

        let(:search) do
          described_class.new do
            filter(term: { foo: 'Foo!' })
          end
        end

        it 'applies the filter' do
          expect(search.to_hash).to eq(bool: { filter: [{ term: { foo: 'Foo!' } }] })
        end
      end

      context 'when the filter is a `Elasticsearch::DSL::Search::Filter` object' do

        let(:search) do
          filter_object = Elasticsearch::DSL::Search::Filter.new do
            term bar: 'Bar!'
          end
          described_class.new do
            filter(filter_object)
          end
        end

        it 'applies the filter' do
          expect(search.to_hash).to eq(bool: { filter: [{ term: { bar: 'Bar!' } }] })
        end
      end
    end
  end
end
