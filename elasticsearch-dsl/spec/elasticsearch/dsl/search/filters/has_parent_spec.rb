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

describe Elasticsearch::DSL::Search::Filters::HasParent do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(has_parent: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#parent_type' do

      before do
        search.parent_type('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:foo][:parent_type]).to eq('bar')
      end
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:query]).to eq('bar')
      end
    end

    describe '#filter' do

      before do
        search.filter('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:filter]).to eq('bar')
      end
    end

    describe '#score_mode' do

      before do
        search.score_mode('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:foo][:score_mode]).to eq('bar')
      end
    end

    describe '#inner_hits' do

      before do
        search.inner_hits(size: 1)
      end

      it 'applies the option' do
        expect(search.to_hash[:has_parent][:foo][:inner_hits]).to eq(size: 1)
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          parent_type 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(has_parent: { foo: { parent_type: 'bar' } })
      end
    end

    context 'when a block is provided to an option method' do

      let(:search) do
        described_class.new do
          parent_type 'bar'
          query do
            match :foo do
              query 'bar'
            end
          end
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(has_parent: { parent_type: 'bar', query: { match: { foo: { query: 'bar'} } } })
      end
    end
  end
end
