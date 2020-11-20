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

describe Elasticsearch::DSL::Search::Queries::Match do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(match: {})
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
        expect(search.to_hash[:match][:query]).to eq('bar')
      end
    end

    describe '#operator' do

      before do
        search.operator('standard')
      end

      it 'applies the option' do
        expect(search.to_hash[:match][:operator]).to eq('standard')
      end
    end

    describe '#type' do

      before do
        search.type(10)
      end

      it 'applies the option' do
        expect(search.to_hash[:match][:type]).to eq(10)
      end
    end

    describe '#auto_generate_synonyms_phrase_query' do
      it 'applies the option' do
        search.auto_generate_synonyms_phrase_query 'false'

        expect(search.to_hash[:match][:auto_generate_synonyms_phrase_query]).to eq('false')
      end
    end

    describe '#fuzzy_transpositions' do
      it 'applies the option' do
        search.fuzzy_transpositions 'false'

        expect(search.to_hash[:match][:fuzzy_transpositions]).to eq('false')
      end
    end
  end

  describe '#initialize' do

    context 'when a hash is provided' do

      let(:search) do
        described_class.new(message: { query: 'test' })
      end

      it 'sets the value' do
        expect(search.to_hash).to eq(match: { message: { query: 'test' } })
      end
    end

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query     'test'
          operator  'and'
          type      'phrase_prefix'
          boost     2
          fuzziness 'AUTO'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:match][:query]).to eq('test')
        expect(search.to_hash[:match][:operator]).to eq('and')
        expect(search.to_hash[:match][:type]).to eq('phrase_prefix')
        expect(search.to_hash[:match][:boost]).to eq(2)
        expect(search.to_hash[:match][:fuzziness]).to eq('AUTO')
      end
    end
  end
end
