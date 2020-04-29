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

describe Elasticsearch::DSL::Search::Queries::QueryString do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(query_string: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    [ 'query',
      'fields',
      'type',
      'default_field',
      'default_operator',
      'allow_leading_wildcard',
      'lowercase_expanded_terms',
      'enable_position_increments',
      'fuzzy_max_expansions',
      'fuzziness',
      'fuzzy_prefix_length',
      'phrase_slop',
      'boost',
      'analyze_wildcard',
      'auto_generate_phrase_queries',
      'minimum_should_match',
      'lenient',
      'locale',
      'use_dis_max',
      'tie_breaker',
      'time_zone'].each do |option|

      describe "##{option}" do

        before do
          search.send(option, 'bar')
        end

        it 'applies the option' do
          expect(search.to_hash[:query_string][option.to_sym]).to eq('bar')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          query 'foo AND bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash[:query_string][:query]).to eq('foo AND bar')
      end
    end
  end
end
