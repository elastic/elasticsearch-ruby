require 'test_helper'

module Elasticsearch
  module Test
    class NestedAggregationIntegrationTest < ::Elasticsearch::Test::IntegrationTestCase
      include Elasticsearch::DSL::Search

      context "A nested aggregation" do
        startup do
          Elasticsearch::Extensions::Test::Cluster.start(nodes: 1) if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?
        end

        setup do
          @port = (ENV['TEST_CLUSTER_PORT'] || 9250).to_i

          @logger =  Logger.new(STDERR)
          @logger.formatter = proc do |severity, datetime, progname, msg|
            color = case severity
              when /INFO/ then :green
              when /ERROR|WARN|FATAL/ then :red
              when /DEBUG/ then :cyan
              else :white
            end
            ANSI.ansi(severity[0] + ' ', color, :faint) + ANSI.ansi(msg, :white, :faint) + "\n"
          end

          @client = Elasticsearch::Client.new host: "localhost:#{@port}", logger: @logger
          @client.indices.delete index: 'articles-test', ignore: 404
          @client.indices.create index: 'articles-test', body: {
            mappings: {
              article: {},
              comment: {
                _routing: { required: true },
                _parent:  { type: 'article' },
                properties: {
                  author: { type: 'string', analyzer: 'keyword' }
                }
              }
            }
          }
          @client.index index: 'articles-test', type: 'article', id: 1,
                        body: { title: 'A', category: 'one'  }
          @client.index index: 'articles-test', type: 'article', id: 2,
                        body: { title: 'B', category: 'one'  }
          @client.index index: 'articles-test', type: 'article', id: 3,
                        body: { title: 'C', category: 'two'  }

          @client.index index: 'articles-test', type: 'comment', parent: '1',
                        body: { author: 'John' }
          @client.index index: 'articles-test', type: 'comment', parent: '1',
                        body: { author: 'Mary' }
          @client.index index: 'articles-test', type: 'comment', parent: '2',
                        body: { author: 'John' }
          @client.index index: 'articles-test', type: 'comment', parent: '2',
                        body: { author: 'Dave' }
          @client.index index: 'articles-test', type: 'comment', parent: '3',
                        body: { author: 'Ruth' }
          @client.indices.refresh index: 'articles-test'
        end

        teardown do
          @client.indices.delete index: 'articles-test', ignore: 404
        end

        should "return the top commenters per article category" do
          response = @client.search index: 'articles-test', size: 0, body: search {
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
