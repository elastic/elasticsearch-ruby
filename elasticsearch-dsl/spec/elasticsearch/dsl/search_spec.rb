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

  context 'when a block is provided' do

    context 'when the top-level scope is accessed in the block' do

      context 'when the method is accessed from within a \'query\' block' do

        let(:s) do
          def query_value
            { title: 'test' }
          end

          search do
            query do
              match query_value
            end
          end
        end

        let(:expected_hash) do
          { query: { match: { title: 'test' } } }
        end

        it 'allows access to the containing scope' do
          expect(s.to_hash).to eq(expected_hash)
        end
      end

      context 'when the method is accessed from within a \'base_component\' block' do

        let(:s) do
          def sort_field
            :category
          end

          search do
            query do
              match title: 'test'
            end
            sort do
              by sort_field, order: 'desc'
            end
          end
        end

        let(:expected_hash) do
          { query: { match: { title: 'test' } }, sort: [{ category: { order: 'desc'} }] }
        end

        it 'allows access to the containing scope' do
          expect(s.to_hash).to eq(expected_hash)
        end
      end

      context 'when the method is accessed from within a \'_not\' block' do

        let(:s) do
          def term_field
            :color
          end

          search do
            query do
              filtered do
                filter do
                  _not do
                    term term_field => 'red'
                  end
                end
              end
            end
          end
        end

        let(:expected_hash) do
          { query: { filtered: { filter: { not: { term: { color: 'red' } } } } } }
        end

        it 'allows access to the containing scope' do
          expect(s.to_hash).to eq(expected_hash)
        end
      end

      context 'when the method is accessed from within a \'aggregation\' block' do

        let(:s) do
          def sum_field
            'clicks'
          end

          def aggregation_name
            :sum_clicks
          end

          search do
            aggregation :clicks_for_tag_one do
              filter terms: { tags: ['one'] } do
                aggregation aggregation_name do
                  sum field: sum_field
                end
              end
            end
          end
        end

        let(:expected_hash) do
          { aggregations: { clicks_for_tag_one: { filter: { terms: { tags: ['one'] } },
                                                  aggregations: { sum_clicks: { sum: { field: 'clicks' } } } } } }
        end

        it 'allows access to the containing scope' do
          expect(s.to_hash).to eq(expected_hash)
        end
      end

      context 'when the method is accessed from within a \'filter\' block' do

        let(:s) do

          def term_field
            :color
          end

          def not_clause(obj)
            obj.instance_eval do
              _not do
                term term_field => 'red'
              end
            end
          end

          search do
            query do
              filtered do
                filter do
                  not_clause(self)
                end
              end
            end
          end
        end

        let(:expected_hash) do
          { query: { filtered: { filter: { not: { term: { color: 'red' } } } } } }
        end

        it 'allows access to the containing scope' do
          expect(s.to_hash).to eq(expected_hash)
        end
      end

      context 'when the method is accessed from within a \'base_aggregation_component\' block' do

        let(:s) do

          def term_field
            :body
          end

          search do
            aggregation :interesting_terms do
              significant_terms do
                field :body
              end
            end
          end
        end

        let(:expected_hash) do
          { aggregations: { interesting_terms: { significant_terms: { field: :body } } } }
        end

        it 'allows access to the containing scope' do
          expect(s.to_hash).to eq(expected_hash)
        end
      end

      context 'when the method is accessed from within a \'base_compound_filter_component\' block' do

        let(:s) do

          def term_field
            'red'
          end

          search do
            query do
              filtered do
                filter do
                  _and do
                    term color: term_field
                    term size: 'xxl'
                  end
                end
              end
            end
          end
        end

        let(:expected_hash) do
          { query: { filtered: { filter: { and: [{ term: { color: 'red' } },
                                                 { term: { size: 'xxl' } }] } } } }
        end

        it 'allows access to the containing scope' do
          expect(s.to_hash).to eq(expected_hash)
        end
      end
    end

  context 'when other methods are used to construct the query' do

    def bool_query(obj)
      obj.instance_eval do
        bool do
          must do
            match foo: 'bar'
          end
          filter do
            term foo: 'bar'
          end
        end
      end
    end

    let(:my_search) do
      search do
        query do
          bool_query(self)
        end
      end
    end

    it 'finds the correct bindings' do
      expect(my_search.to_hash).to eq(query: { bool: { filter: [{ term: { foo: 'bar' } }],
                                                     must: [{ match: { foo: 'bar' } }] } })
    end
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
