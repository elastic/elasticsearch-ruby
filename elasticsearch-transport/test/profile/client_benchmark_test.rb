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

class Elasticsearch::Transport::ClientProfilingTest < Elasticsearch::Test::ProfilingTest
  startup do
    Elasticsearch::Extensions::Test::Cluster.start if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?
  end

  context "Elasticsearch client benchmark" do
    setup do
      @port = (ENV['TEST_CLUSTER_PORT'] || 9250).to_i
      client = Elasticsearch::Client.new host: "localhost:#{@port}", adapter: ::Faraday.default_adapter
      client.perform_request 'DELETE', 'ruby_test_benchmark' rescue nil
      client.perform_request 'PUT',   'ruby_test_benchmark', {}, {settings: {index: {number_of_shards: 1, number_of_replicas: 0}}}
      100.times do client.perform_request 'POST',   'ruby_test_benchmark_search/test', {}, {foo: 'bar'}; end
      client.perform_request 'POST',   'ruby_test_benchmark_search/_refresh'
    end
    teardown do
      client = Elasticsearch::Client.new host: "localhost:#{@port}"
      client.perform_request 'DELETE', 'ruby_test_benchmark' rescue nil
      client.perform_request 'DELETE', 'ruby_test_benchmark_search' rescue nil
    end

    context "with a single-node cluster and the default adapter" do
      setup do
        @client = Elasticsearch::Client.new hosts: "localhost:#{@port}", adapter: ::Faraday.default_adapter
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document" do
        @client.perform_request 'POST', 'ruby_test_benchmark/test', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'GET', 'ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end

    context "with a two-node cluster and the default adapter" do
      setup do
        @client = Elasticsearch::Client.new hosts: ["localhost:#{@port}", "localhost:#{@port+1}"], adapter: ::Faraday.default_adapter
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document"do
        @client.perform_request 'POST', 'ruby_test_benchmark/test', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'GET', 'ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end

    context "with a single-node cluster and the Curb client" do
      setup do
        require 'curb'
        require 'elasticsearch/transport/transport/http/curb'
        @client = Elasticsearch::Client.new host: "localhost:#{@port}",
                                            transport_class: Elasticsearch::Transport::Transport::HTTP::Curb
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document" do
        @client.perform_request 'POST', 'ruby_test_benchmark/test', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'GET', 'ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end

    context "with a single-node cluster and the Typhoeus client" do
      setup do
        require 'typhoeus'
        require 'typhoeus/adapters/faraday'
        @client = Elasticsearch::Client.new host: "localhost:#{@port}", adapter: :typhoeus
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document" do
        @client.perform_request 'POST', 'ruby_test_benchmark/test', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'GET', 'ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end

    context "with a single-node cluster and the Patron adapter" do
      setup do
        require 'patron'
        @client = Elasticsearch::Client.new host: "localhost:#{@port}", adapter: :patron
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document" do
        @client.perform_request 'POST', 'ruby_test_benchmark/test', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'GET', 'ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end
  end
end
