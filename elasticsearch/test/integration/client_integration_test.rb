# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'test_helper'
require 'logger'
require 'ansi'

module Elasticsearch
  module Test
    class ClientIntegrationTest < Elasticsearch::Test::IntegrationTestCase
      context "Elasticsearch client" do
        setup do
          system "curl -X DELETE http://#{TEST_HOST}:#{TEST_PORT}/_all > /dev/null 2>&1"

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

          @client = Elasticsearch::Client.new host: "#{TEST_HOST}:#{TEST_PORT}", logger: (ENV['QUIET'] ? nil : @logger)
        end

        should "perform the API methods" do
          assert_nothing_raised do
            # Index a document
            #
            @client.index index: 'test-index', id: '1', body: { title: 'Test', type: 'test-type' }

            # Refresh the index
            #
            @client.indices.refresh(index: 'test-index')

            # Search
            #
            response = @client.search(index: 'test-index', body: { query: { match: { title: 'test' } } })

            assert_equal(1, response['hits']['total']['value'])
            assert_equal('Test', response['hits']['hits'][0]['_source']['title'])

            # Delete the index
            #
            @client.indices.delete(index: 'test-index')
          end
        end

        should 'report the right meta header' do
          headers = @client.transport.connections.first.connection.headers
          assert_match(/^es=#{Elasticsearch::VERSION}/, headers['x-elastic-client-meta'])
        end
      end
    end
  end
end
