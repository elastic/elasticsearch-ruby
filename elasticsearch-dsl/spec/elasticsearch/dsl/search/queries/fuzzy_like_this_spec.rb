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

describe Elasticsearch::DSL::Search::Queries::FuzzyLikeThis do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(fuzzy_like_this: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#fields' do

      before do
        search.fields('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this][:fields]).to eq('bar')
      end
    end

    describe '#like_text' do

      before do
        search.like_text('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this][:like_text]).to eq('bar')
      end
    end

    describe '#fuzziness' do

      before do
        search.fuzziness('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this][:fuzziness]).to eq('bar')
      end
    end

    describe '#analyzer' do

      before do
        search.analyzer('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this][:analyzer]).to eq('bar')
      end
    end

    describe '#max_query_terms' do

      before do
        search.max_query_terms('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this][:max_query_terms]).to eq('bar')
      end
    end

    describe '#prefix_length' do

      before do
        search.prefix_length('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this][:prefix_length]).to eq('bar')
      end
    end

    describe '#boost' do

      before do
        search.boost('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:fuzzy_like_this][:boost]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          fields ['foo']
          like_text 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:fuzzy_like_this][:like_text]).to eq('bar')
        expect(search.to_hash[:fuzzy_like_this][:fields]).to eq(['foo'])
      end
    end
  end
end
