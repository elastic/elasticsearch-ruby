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

describe Elasticsearch::DSL::Search::Filters::Bool do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(bool: {})
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(must: [ { term: { foo: 'bar' } } ])
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(bool: { must: [ { term: { foo: 'bar' } } ] })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          must { term foo: 'bar' }
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(bool: { must: [ { term: { foo: 'bar' } } ] })
      end

      context 'when the block calls multiple methods' do

        let(:search) do
          described_class.new do
            must     { term foo: 'bar' }
            must_not { term moo: 'bam' }
            should   { term xoo: 'bax' }
          end
        end

        it 'executes the block' do
          expect(search.to_hash).to eq(bool:
                                           { must:     [ { term: { foo: 'bar' } } ],
                                             must_not: [ { term: { moo: 'bam' } } ],
                                             should:   [ { term: { xoo: 'bax' } } ]
                                           })
        end
      end

      context 'when the block calls multiple conditions' do

        let(:search) do
          described_class.new do
            must { term foo: 'bar' }
            must { term moo: 'bam' }

            should { term xoo: 'bax' }
            should { term zoo: 'baz' }
          end
        end

        it 'executes the block' do
          expect(search.to_hash).to eq(bool:
                                           { must:     [ { term: { foo: 'bar' } }, { term: { moo: 'bam' } } ],
                                             should:   [ { term: { xoo: 'bax' } }, { term: { zoo: 'baz' } } ]
                                           })
        end
      end
    end
  end

  describe '#must' do

    before do
      search.must { term foo: 'bar' }
    end

    it 'applies the condition' do
      expect(search.to_hash).to eq(bool: { must: [ { term: { foo: 'bar' } } ] })
    end

    context 'when the method is called more than once' do

      before do
        search.must { term foo: 'bar' }
        search.must { term moo: 'bam' }
      end

      it 'applies the conditions' do
        expect(search.to_hash).to eq(bool: { must: [ { term: { foo: 'bar' } }, { term: { moo: 'bam' } } ] })
      end
    end
  end

  describe '#should' do

    before do
      search.should { term xoo: 'bax' }
    end

    it 'applies the condition' do
      expect(search.to_hash).to eq(bool: { should: [ { term: { xoo: 'bax' } } ] })
    end
  end

  context 'when methods are chained' do

    before do
      search.must { term foo: 'bar' }
      search.must { term foo: 'baz' }.must { term moo: 'bam' }
      search.must_not { term foo: 'biz' }
      search.should { term foo: 'bor' }
    end

    it 'applies all the conditions' do
      expect(search.to_hash).to eq(bool: { must: [{ term: { foo: 'bar' } }, { term: { foo: 'baz' } },
                                                  { term: { moo: 'bam' } }],
                                                    must_not: [{ term: { foo: 'biz' } }],
                                           should: [{ term: { foo: 'bor' } }] })
    end
  end
end
