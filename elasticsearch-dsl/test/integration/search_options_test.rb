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

require 'test_helper'

module Elasticsearch
  module Test
    class SearchOptionsIntegrationTest < ::Elasticsearch::Test::IntegrationTestCase
      include Elasticsearch::DSL::Search

      context "Search options" do
        setup do
          @client.indices.create index: 'test'
          @client.index index: 'test', id: '1', body: { title: 'Test' }
          @client.index index: 'test', id: '2', body: { title: 'Rest' }
          @client.indices.refresh index: 'test'
        end

        should "explain the match" do
          response = @client.search index: 'test', body: search {
            query   { match title: 'test' }
            explain true
          }.to_hash

          assert_equal 1, response['hits']['total']['value']
          assert_not_nil  response['hits']['hits'][0]['_explanation']
        end
      end
    end
  end
end
