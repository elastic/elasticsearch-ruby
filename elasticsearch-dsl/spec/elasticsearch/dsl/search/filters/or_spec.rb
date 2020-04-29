# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe Elasticsearch::DSL::Search::Filters::Or do

  let(:search) do
    described_class.new
  end

  it 'responds to enumerable methods' do
    expect(search.empty?).to be(true)
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(or: {})
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(filters: [ { term: { foo: 'bar' } } ])
      end

      it 'applies the hash' do
        expect(search.to_hash).to eq(or: { filters: [ { term: { foo: 'bar' } } ] })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          term foo: 'bar'
          term moo: 'mam'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(or: [ {term: { foo: 'bar'}}, {term: { moo: 'mam'}} ])
      end
    end
  end

  context 'when the filter is appended to' do

    before do
      search << { term: { foo: 'bar' } }
    end

    it 'appends the predicate' do
      expect(search.to_hash).to eq(or: [ { term: { foo: 'bar' } } ])
    end
  end
end
