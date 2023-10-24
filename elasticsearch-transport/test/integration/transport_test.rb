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

class Elasticsearch::Transport::Transport::ClientIntegrationTest < Elasticsearch::Test::IntegrationTestCase
  startup do
    Elasticsearch::Extensions::Test::Cluster.start(number_of_nodes: 2) if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 2)
  end

  shutdown do
    Elasticsearch::Extensions::Test::Cluster.stop(number_of_nodes: 2) if ENV['SERVER'] and Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 2)
  end

  context "Transport" do
    setup do
      @host, @port = ELASTICSEARCH_HOSTS.first.split(':')
      @hosts = { hosts: [ { host: @host, port: @port } ] }
    end

    should "use the default Faraday adapter" do
      transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(@hosts) do |f|
        f.response :logger
      end

      client = Elasticsearch::Transport::Client.new transport: transport
      assert_equal(client.transport.connections.first.connection.adapter, Faraday::Adapter::NetHttp)
      client.perform_request 'GET', ''
    end

    unless jruby?
      should "allow to customize the Faraday adapter to Typhoeus" do
        if is_faraday_v2?
          require 'faraday/typhoeus'
        else
          require 'typhoeus'
        end

        transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(@hosts) do |f|
          f.response :logger
          f.adapter  :typhoeus
        end

        client = Elasticsearch::Transport::Client.new transport: transport
        assert_equal(client.transport.connections.first.connection.adapter, Faraday::Adapter::Typhoeus)
        client.perform_request 'GET', ''
      end

      should "use the Curb client" do
        require 'curb'
        require 'elasticsearch/transport/transport/http/curb'
        transport = Elasticsearch::Transport::Transport::HTTP::Curb.new(@hosts) do |curl|
          curl.verbose = true
        end

        client = Elasticsearch::Transport::Client.new transport: transport
        assert_equal(client.transport.class, Elasticsearch::Transport::Transport::HTTP::Curb)
        client.perform_request 'GET', ''
      end

      should "deserialize JSON responses in the Curb client" do
        require 'curb'
        require 'elasticsearch/transport/transport/http/curb'
        transport = Elasticsearch::Transport::Transport::HTTP::Curb.new(@hosts) do |curl|
          curl.verbose = true
        end

        client = Elasticsearch::Transport::Client.new transport: transport
        response = client.perform_request 'GET', ''

        assert_respond_to(response.body, :to_hash)
        assert_not_nil response.body['name']
        assert_equal 'application/json', response.headers['content-type']
      end

      should 'allow to customize the Faraday adapter to Patron' do
        if is_faraday_v2?
          require 'faraday/patron'
        else
          require 'patron'
        end
        transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(@hosts) do |f|
          f.response :logger
          f.adapter  :patron
        end

        client = Elasticsearch::Transport::Client.new(transport: transport)
        assert_equal(client.transport.connections.first.connection.adapter, Faraday::Adapter::Patron)
        client.perform_request 'GET', ''
      end

      should "allow to customize the Faraday adapter to NetHttpPersistent" do
        require 'faraday/net_http_persistent'

        transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(@hosts) do |f|
          f.response :logger
          f.adapter  :net_http_persistent
        end

        client = Elasticsearch::Transport::Client.new transport: transport
        assert_equal(client.transport.connections.first.connection.adapter, Faraday::Adapter::NetHttpPersistent)
        client.perform_request 'GET', ''
      end

      should 'allow to customize the Faraday adapter to HTTPClient' do
        require 'faraday/httpclient'

        transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(@hosts) do |f|
          f.response :logger
          f.adapter  :httpclient
        end

        client = Elasticsearch::Transport::Client.new(transport: transport)
        assert_equal(client.transport.connections.first.connection.adapter, Faraday::Adapter::HTTPClient)
        client.perform_request 'GET', ''
      end

      should "allow to define connection parameters and pass them" do
        transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(
          hosts: [ { host: @host, port: @port } ],
          options: { transport_options: { params: { :format => 'yaml' } } }
        )
        client = Elasticsearch::Transport::Client.new transport: transport
        response = client.perform_request 'GET', ''

        assert response.body.start_with?("---\n"), "Response body should be YAML: #{response.body.inspect}"
      end
    end
  end
end
