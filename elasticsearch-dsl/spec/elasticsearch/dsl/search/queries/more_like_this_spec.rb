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

describe Elasticsearch::DSL::Search::Queries::MoreLikeThis do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(more_like_this: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'fields',
      'like_text',
      'min_term_freq',
      'max_query_terms',
      'docs',
      'ids',
      'include',
      'exclude',
      'percent_terms_to_match',
      'stop_words',
      'min_doc_freq',
      'max_doc_freq',
      'min_word_length',
      'max_word_length',
      'boost_terms',
      'boost',
      'analyzer' ].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:more_like_this][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          fields ['foo', 'bar']
          like_text 'abc'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:more_like_this][:fields]).to eq(['foo', 'bar'])
        expect(search.to_hash[:more_like_this][:like_text]).to eq('abc')
      end
    end
  end
end
