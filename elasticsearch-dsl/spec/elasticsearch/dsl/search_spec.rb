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

describe Elasticsearch::DSL::Search do

  include Elasticsearch::DSL

  describe '#initialize' do

    let(:s) do
      search do
        query do
          match title: 'test'
        end
      end
    end

    let(:expected_hash) do
      { query: { match: { title: 'test' } } }
    end

    it 'creates the search definition' do
      expect(s.to_hash).to eq(expected_hash)
    end
  end

  describe '#collapse' do

    let(:s) do
      search do
        query do
          match title: 'test'
        end
        collapse :user do
          max_concurrent_group_searches 4
          inner_hits 'last_tweet' do
            size 10
            from 5
            sort do
              by :date, order: 'desc'
              by :likes, order: 'asc'
            end
          end
        end
      end
    end

    let(:inner_hits_hash) do
      { name: 'last_tweet',
        size: 10,
        from: 5,
        sort: [ { date: { order: 'desc' } },
               { likes: { order: 'asc' } }]
      }
    end

    let(:expected_hash) do
      { query: { match: { title: 'test' } },
        collapse: { field: :user,
                    max_concurrent_group_searches: 4,
                    inner_hits: inner_hits_hash }  }
    end

    it 'sets the field name' do
      expect(s.to_hash[:collapse][:field]).to eq(:user)
    end

    it 'sets the max_concurrent_group_searches option' do
      expect(s.to_hash[:collapse][:max_concurrent_group_searches]).to eq(4)
    end

    it 'sets the inner_hits' do
      expect(s.to_hash[:collapse][:inner_hits]).to eq(inner_hits_hash)
    end

    it 'constructs the correct hash' do
      expect(s.to_hash).to eq(expected_hash)
    end
  end
end
