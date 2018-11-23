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

describe Elasticsearch::DSL::Search::Queries::MatchPhrase do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(match_phrase: {})
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
        expect(search.to_hash[:match_phrase][:query]).to eq('bar')
      end
    end

    describe '#analyzer' do

      before do
        search.analyzer('standard')
      end

      it 'applies the option' do
        expect(search.to_hash[:match_phrase][:analyzer]).to eq('standard')
      end
    end
    
    describe '#boost' do

      before do
        search.boost(10)
      end

      it 'applies the option' do
        expect(search.to_hash[:match_phrase][:boost]).to eq(10)
      end
    end

    describe '#slop' do

      before do
        search.slop(1)
      end

      it 'applies the option' do
        expect(search.to_hash[:match_phrase][:slop]).to eq(1)
      end
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(message: { query: 'test' })
      end

      it 'sets the value' do
        expect(search.to_hash).to eq(match_phrase: { message: { query: 'test' } })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query 'test'
          slop 1
          boost 2
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:match_phrase][:query]).to eq('test')
        expect(search.to_hash[:match_phrase][:boost]).to eq(2)
        expect(search.to_hash[:match_phrase][:slop]).to eq(1)
      end
    end
  end
end
