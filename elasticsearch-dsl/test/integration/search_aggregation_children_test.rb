require 'test_helper'

module Elasticsearch
  module Test
    class ChildrenAggregationIntegrationTest < ::Elasticsearch::Test::IntegrationTestCase
      include Elasticsearch::DSL::Search

      context "A children aggregation" do
        startup do
          Elasticsearch::Extensions::Test::Cluster.start(number_of_nodes: 1) if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 1)
        end

        setup do
          @client.indices.create index: 'articles-and-comments', body: {
            mappings: {
              _doc: {
                properties: {
                  title:    { type: 'text' },
                  category: { type: 'keyword' },
                  join_field: { type: 'join', relations: { article: 'comment' } },
                  author: { type: 'keyword'}
                }
              }
            }
          }

          @client.index index: 'articles-and-comments', id: 1, type: '_doc',
                        body: { title: 'A', category: 'one', join_field: 'article' }
          @client.index index: 'articles-and-comments', id: 2, type: '_doc',
                        body: { title: 'B', category: 'one', join_field: 'article' }
          @client.index index: 'articles-and-comments', id: 3, type: '_doc',
                        body: { title: 'C', category: 'two', join_field: 'article' }

          @client.index index: 'articles-and-comments', routing: '1', type: '_doc',
                        body: { author: 'John', join_field: { name: 'comment', parent: 1 } }
          @client.index index: 'articles-and-comments', routing: '1', type: '_doc',
                        body: { author: 'Mary',join_field: { name: 'comment', parent: 1 } }
          @client.index index: 'articles-and-comments', routing: '2', type: '_doc',
                        body: { author: 'John', join_field: { name: 'comment', parent: 2 } }
          @client.index index: 'articles-and-comments', routing: '2', type: '_doc',
                        body: { author: 'Dave', join_field: { name: 'comment', parent: 2 } }
          @client.index index: 'articles-and-comments', routing: '3', type: '_doc',
                        body: { author: 'Ruth',join_field: { name: 'comment', parent: 3 } }
          @client.indices.refresh index: 'articles-and-comments'
        end

        should "return the top commenters per article category" do
          response = @client.search index: 'articles-and-comments', size: 0, body: search {
            aggregation :top_categories do
              terms field: 'category' do
                aggregation :comments do
                  children type: 'comment' do
                    aggregation :top_authors do
                      terms field: 'author'
                    end
                  end
                end
              end
            end
          }.to_hash

          assert_equal 'one',  response['aggregations']['top_categories']['buckets'][0]['key']
          assert_equal 3,      response['aggregations']['top_categories']['buckets'][0]['comments']['top_authors']['buckets'].size
          assert_equal 'John', response['aggregations']['top_categories']['buckets'][0]['comments']['top_authors']['buckets'][0]['key']

        end
      end
    end
  end
end
