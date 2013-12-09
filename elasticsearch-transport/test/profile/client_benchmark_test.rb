require 'test_helper'

class Elasticsearch::Transport::ClientProfilingTest < Elasticsearch::Test::ProfilingTest
  startup do
    Elasticsearch::Extensions::Test::Cluster.start if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?
  end

  context "Elasticsearch client benchmark" do
    setup do
      @port = (ENV['TEST_CLUSTER_PORT'] || 9250).to_i
      client = Elasticsearch::Client.new host: "localhost:#{@port}"
      client.perform_request 'DELETE', '/ruby_test_benchmark/' rescue nil
      client.perform_request 'POST',   '/ruby_test_benchmark/', {index: {number_of_shards: 1, number_of_replicas: 0}}
      100.times do client.perform_request 'POST',   '/ruby_test_benchmark_search/test/', {}, {foo: 'bar'}; end
      client.perform_request 'POST',   '/ruby_test_benchmark_search/_refresh'
    end
    teardown do
      client = Elasticsearch::Client.new host: "localhost:#{@port}"
      client.perform_request 'DELETE', '/ruby_test_benchmark/'
      client.perform_request 'DELETE', '/ruby_test_benchmark_search/'
    end

    context "with a single-node cluster" do
      setup do
        @client = Elasticsearch::Client.new hosts: "localhost:#{@port}"
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document" do
        @client.perform_request 'POST', '/ruby_test_benchmark/test/', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'POST', '/ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end

    context "with a two-node cluster" do
      setup do
        @client = Elasticsearch::Client.new hosts: ["localhost:#{@port}", "localhost:#{@port+1}"]
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document"do
        @client.perform_request 'POST', '/ruby_test_benchmark/test/', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'POST', '/ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
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
        @client.perform_request 'POST', '/ruby_test_benchmark/test/', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'POST', '/ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end

    context "with a single-node cluster and the Typhoeus client" do
      setup do
        require 'typhoeus'
        require 'typhoeus/adapters/faraday'

        transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new \
          :hosts => [ { :host => 'localhost', :port => @port } ] do |f|
            f.adapter  :typhoeus
          end

        @client = Elasticsearch::Client.new transport: transport
      end

      measure "get the cluster info", count: 1_000 do
        @client.perform_request 'GET', ''
      end

      measure "index a document" do
        @client.perform_request 'POST', '/ruby_test_benchmark/test/', {}, {foo: 'bar'}
      end

      measure "search" do
        @client.perform_request 'POST', '/ruby_test_benchmark_search/test/_search', {}, {query: {match: {foo: 'bar'}}}
      end
    end

  end

end
