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

require 'test_helper'
require 'logger'

module Elasticsearch
  module Test
    class ClientIntegrationTest < Elasticsearch::Test::IntegrationTestCase
      startup do
        Elasticsearch::Extensions::Test::Cluster.start(number_of_nodes: 2) if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 2)
      end

      shutdown do
        Elasticsearch::Extensions::Test::Cluster.stop(number_of_nodes: 2) if ENV['SERVER'] and Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 2)
      end

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
            @client.index index: 'test-index', type: 'test-type', id: '1', body: { title: 'Test' }

            # Refresh the index
            #
            @client.indices.refresh index: 'test-index'

            # Search
            #
            response = @client.search index: 'test-index', body: { query: { match: { title: 'test' } } }

            assert_equal 1,      response['hits']['total']['value']
            assert_equal 'Test', response['hits']['hits'][0]['_source']['title']

            # Delete the index
            #
            @client.indices.delete index: 'test-index'
          end
        end

      end
    end
  end
end
