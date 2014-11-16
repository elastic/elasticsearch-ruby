require 'test_helper'

module Elasticsearch
  module Test
    class AggregationsIntegrationTest < ::Elasticsearch::Test::IntegrationTestCase
      include Elasticsearch::DSL::Search

      CLIENT = Elasticsearch::Client.new url: 'localhost:'

      context "Aggregations integration" do
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
          @client.indices.delete index: 'test' rescue Elasticsearch::Transport::Transport::Errors::NotFound; nil
          @client.indices.create index: 'test' rescue Elasticsearch::Transport::Transport::Errors::NotFound; nil
          @client.index index: 'test', type: 'd', id: '1', body: { tags: ['one'], clicks: 5 }
          @client.index index: 'test', type: 'd', id: '2', body: { tags: ['one', 'two'], clicks: 15 }
          @client.index index: 'test', type: 'd', id: '3', body: { tags: ['one', 'three'], clicks: 20 }
          @client.indices.refresh index: 'test'
        end

        teardown do
          @client.indices.delete index: 'test', ignore: [404]
        end

        context "with a terms aggregation" do
          should "return tag counts" do
            response = @client.search index: 'test', body: search {
              aggregation :tags do
                terms field: 'tags'
              end
            }.to_hash

            assert_equal 3, response['aggregations']['tags']['buckets'].size
            assert_equal 'one', response['aggregations']['tags']['buckets'][0]['key']
          end

          should "return tag counts per clicks range" do
            response = @client.search index: 'test', body: search {
              aggregation :clicks do
                range field: 'clicks' do
                  key :low, to: 10
                  key :mid, from: 10, to: 20

                  aggregation :tags do
                    terms field: 'tags'
                  end
                end
              end
            }.to_hash

            assert_equal 2, response['aggregations']['clicks']['buckets'].size
            assert_equal 1, response['aggregations']['clicks']['buckets']['low']['doc_count']
            assert_equal 'one', response['aggregations']['clicks']['buckets']['low']['tags']['buckets'][0]['key']
          end
        end

      end
    end
  end
end
