# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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

    context 'when an object instance is provided' do

      let(:search) do
        described_class.new.must(Elasticsearch::DSL::Search::Queries::Match.new foo: 'bar')
      end

      it 'applies the condition' do
        expect(search.to_hash).to eq(bool: {must: [ {match: { foo: 'bar' }} ] })
      end

      context 'when multiple option methods are called' do

        let(:search) do
          described_class.new do
            should(Elasticsearch::DSL::Search::Queries::Term.new(tag: 'wow'))
            should(Elasticsearch::DSL::Search::Queries::Term.new(tag: 'elasticsearch'))

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
            must(Elasticsearch::DSL::Search::Queries::Match.new foo: 'bar')
            must(Elasticsearch::DSL::Search::Queries::Match.new moo: 'bam')

            should(Elasticsearch::DSL::Search::Queries::Match.new xoo: 'bax')
            should(Elasticsearch::DSL::Search::Queries::Match.new zoo: 'baz')
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
