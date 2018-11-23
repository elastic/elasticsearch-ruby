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

describe Elasticsearch::DSL::Search::Queries::Indices do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(indices: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#indices' do

      before do
        search.indices('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:indices]).to eq('bar')
      end
    end

    describe '#query' do

      before do
        search.query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:query]).to eq('bar')
      end
    end

    describe '#no_match_query' do

      before do
        search.no_match_query('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:indices][:no_match_query]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          indices 'bar'
          query term: { foo: 'bar' }
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(indices: { indices: 'bar', query: { term: { foo: 'bar' } } } )
      end
    end
  end
end
