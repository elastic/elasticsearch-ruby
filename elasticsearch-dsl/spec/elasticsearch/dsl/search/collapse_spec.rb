# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::DSL::Search::Collapse do

  include Elasticsearch::DSL

  describe '#initialize' do

    let(:coll) do
      Elasticsearch::DSL::Search::Collapse.new :user
    end

    let(:expected_hash) do
      { field: :user }
    end

    it 'sets the field' do
      expect(coll.to_hash).to eq(expected_hash)
    end
  end

  describe '#max_concurrent_group_searches' do

    let(:coll) do
      Elasticsearch::DSL::Search::Collapse.new :user do
        max_concurrent_group_searches 4
      end
    end

    it 'sets the field' do
      expect(coll.to_hash[:field]).to eq(:user)
    end

    it 'sets the max_concurrent_group_searches option' do
      expect(coll.to_hash[:max_concurrent_group_searches]).to eq(4)
    end
  end

  describe '#inner_hits' do

    let(:coll) do
      Elasticsearch::DSL::Search::Collapse.new :user do
        max_concurrent_group_searches 4
        inner_hits 'last_tweet' do
          size 10
          from 5
          _source ['date']
          sort do
            by :date, order: 'desc'
            by :likes, order: 'asc'
          end
        end
      end
    end

    let(:inner_hits_hash) do
      { name: 'last_tweet',
        size: 10,
        from: 5,
        _source: ['date'],
        sort: [ { date: { order: 'desc' } },
                { likes: { order: 'asc' } } ]
      }
    end

    it 'sets the field' do
      expect(coll.to_hash[:field]).to eq(:user)
    end

    it 'sets the max_concurrent_group_searches option' do
      expect(coll.to_hash[:max_concurrent_group_searches]).to eq(4)
    end

    it 'sets the inner_hits' do
      expect(coll.to_hash[:inner_hits]).to eq(inner_hits_hash)
    end
  end
end
