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

describe Elasticsearch::Transport::Client do

  let(:client) do
    described_class.new.tap do |_client|
      allow(_client).to receive(:__build_connections)
    end
  end

  it 'is aliased as Elasticsearch::Client' do
    expect(Elasticsearch::Client.new).to be_a(described_class)
  end

  it 'has a default transport' do
    expect(client.transport).to be_a(Elasticsearch::Transport::Client::DEFAULT_TRANSPORT_CLASS)
  end

  it 'uses Faraday as the default transport' do
    expect(client.transport.connections.first.connection.headers['User-Agent']).to match(/Faraday/)
  end

  it 'sets the \'Content-Type\' header to \'application/json\' by default' do
    expect(client.transport.options[:transport_options][:headers]['Content-Type']).to eq('application/json')
  end

  it 'uses localhost by default' do
    expect(client.transport.hosts[0][:host]).to eq('localhost')
  end

  describe 'adapter' do

    context 'when no adapter is specified' do

      let(:adapter) do
        client.transport.connections.all.first.connection.builder.handlers
      end

      it 'uses Faraday NetHttp' do
        expect(adapter).to include(Faraday::Adapter::NetHttp)
      end
    end

    context 'when the adapter is specified' do

      let(:adapter) do
        client.transport.connections.all.first.connection.builder.handlers
      end

      let(:client) do
        described_class.new(adapter: :typhoeus)
      end

      it 'uses Faraday' do
        expect(adapter).to include(Faraday::Adapter::Typhoeus)
      end
    end

    context 'when the adapter can be detected', unless: jruby? do

      around do |example|
        require 'patron'; load 'patron.rb'
        example.run
      end

      let(:adapter) do
        client.transport.connections.all.first.connection.builder.handlers
      end

      it 'uses the detected adapter' do
        expect(adapter).to include(Faraday::Adapter::Patron)
      end
    end

    context 'when the Faraday adapter is configured' do

      let(:client) do
        described_class.new do |faraday|
          faraday.adapter :typhoeus
          faraday.response :logger
        end
      end

      let(:handlers) do
        client.transport.connections.all.first.connection.builder.handlers
      end

      it 'sets the adapter' do
        expect(handlers).to include(Faraday::Adapter::Typhoeus)
      end

      it 'sets the logger' do
        expect(handlers).to include(Faraday::Response::Logger)
      end
    end
  end

  shared_examples_for 'a client that extracts hosts' do

    context 'when the hosts are a String' do

      let(:host) do
        'myhost'
      end

      it 'extracts the host' do
        expect(hosts[0][:host]).to eq('myhost')
        expect(hosts[0][:protocol]).to eq('http')
        expect(hosts[0][:port]).to be(9200)
      end

      context 'when a path is specified' do

        let(:host) do
          'https://myhost:8080/api'
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('https')
          expect(hosts[0][:path]).to eq('/api')
          expect(hosts[0][:port]).to be(8080)
        end
      end

      context 'when a scheme is specified' do

        let(:host) do
          'https://myhost:8080'
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('https')
          expect(hosts[0][:port]).to be(8080)
        end
      end

      context 'when credentials are specified' do

        let(:host) do
          'http://USERNAME:PASSWORD@myhost:8080'
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('http')
          expect(hosts[0][:user]).to eq('USERNAME')
          expect(hosts[0][:password]).to eq('PASSWORD')
          expect(hosts[0][:port]).to be(8080)
        end
      end

      context 'when there is a trailing slash' do

        let(:host) do
          'http://myhost/'
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('http')
          expect(hosts[0][:path]).to eq('')
        end
      end

      context 'when there is a trailing slash with a path' do

        let(:host) do
          'http://myhost/foo/bar/'
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('http')
          expect(hosts[0][:path]).to eq('/foo/bar')
        end
      end
    end

    context 'when the hosts are a Hash' do

      let(:host) do
        { :host => 'myhost', :scheme => 'https' }
      end

      it 'extracts the host' do
        expect(hosts[0][:host]).to eq('myhost')
        expect(hosts[0][:scheme]).to eq('https')
        expect(hosts[0][:port]).to be(9200)
      end

      context 'when the port is specified as a String' do

        let(:host) do
          { host: 'myhost', scheme: 'https', port: '443' }
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('https')
          expect(hosts[0][:port]).to be(443)
        end
      end

      context 'when the port is specified as an Integer' do

        let(:host) do
          { host: 'myhost', scheme: 'https', port: 443 }
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('https')
          expect(hosts[0][:port]).to be(443)
        end
      end
    end

    context 'when the hosts are a Hashie:Mash' do

      let(:host) do
        Hashie::Mash.new(host: 'myhost', scheme: 'https')
      end

      it 'extracts the host' do
        expect(hosts[0][:host]).to eq('myhost')
        expect(hosts[0][:scheme]).to eq('https')
        expect(hosts[0][:port]).to be(9200)
      end

      context 'when the port is specified as a String' do

        let(:host) do
          Hashie::Mash.new(host: 'myhost', scheme: 'https', port: '443')
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('https')
          expect(hosts[0][:port]).to be(443)
        end
      end

      context 'when the port is specified as an Integer' do

        let(:host) do
          Hashie::Mash.new(host: 'myhost', scheme: 'https', port: 443)
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:scheme]).to eq('https')
          expect(hosts[0][:port]).to be(443)
        end
      end
    end

    context 'when the hosts are an array' do

      context 'when there is one host' do

        let(:host) do
          ['myhost']
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('myhost')
          expect(hosts[0][:protocol]).to eq('http')
          expect(hosts[0][:port]).to be(9200)
        end
      end

      context 'when there is more than one host' do

        let(:host) do
          ['host1', 'host2']
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('host1')
          expect(hosts[0][:protocol]).to eq('http')
          expect(hosts[0][:port]).to be(9200)
          expect(hosts[1][:host]).to eq('host2')
          expect(hosts[1][:protocol]).to eq('http')
          expect(hosts[1][:port]).to be(9200)
        end
      end

      context 'when ports are also specified' do

        let(:host) do
          ['host1:1000', 'host2:2000']
        end

        it 'extracts the host' do
          expect(hosts[0][:host]).to eq('host1')
          expect(hosts[0][:protocol]).to eq('http')
          expect(hosts[0][:port]).to be(1000)
          expect(hosts[1][:host]).to eq('host2')
          expect(hosts[1][:protocol]).to eq('http')
          expect(hosts[1][:port]).to be(2000)
        end
      end
    end

    context 'when the hosts is an instance of URI' do

      let(:host) do
        URI.parse('https://USERNAME:PASSWORD@myhost:4430')
      end

      it 'extracts the host' do
        expect(hosts[0][:host]).to eq('myhost')
        expect(hosts[0][:scheme]).to eq('https')
        expect(hosts[0][:port]).to be(4430)
        expect(hosts[0][:user]).to eq('USERNAME')
        expect(hosts[0][:password]).to eq('PASSWORD')
      end
    end

    context 'when the hosts is invalid' do

      let(:host) do
        123
      end

      it 'extracts the host' do
        expect {
          hosts
        }.to raise_exception(ArgumentError)
      end
    end
  end

  context 'when hosts are specified with the \'host\' key' do

    let(:client) do
      described_class.new(hosts: ['host1', 'host2', 'host3', 'host4'], randomize_hosts: true)
    end

    let(:hosts) do
      client.transport.hosts
    end

    it 'sets the hosts in random order' do
      expect(hosts.all? { |host| client.transport.hosts.include?(host) }).to be(true)
    end
  end

  context 'when hosts are specified with the \'host\' key' do

    let(:client) do
      described_class.new(host: host)
    end

    let(:hosts) do
      client.transport.hosts
    end

    it_behaves_like 'a client that extracts hosts'
  end

  context 'when hosts are specified with the \'hosts\' key' do

    let(:client) do
      described_class.new(host: host)
    end

    let(:hosts) do
      client.transport.hosts
    end

    it_behaves_like 'a client that extracts hosts'
  end

  context 'when hosts are specified with the \'url\' key' do

    let(:client) do
      described_class.new(host: host)
    end

    let(:hosts) do
      client.transport.hosts
    end

    it_behaves_like 'a client that extracts hosts'
  end

  context 'when hosts are specified with the \'urls\' key' do

    let(:client) do
      described_class.new(host: host)
    end

    let(:hosts) do
      client.transport.hosts
    end

    it_behaves_like 'a client that extracts hosts'
  end

  context 'when the URL is set in the ELASTICSEARCH_URL environment variable' do

    context 'when there is only one host specified' do

      around do |example|
        before_url = ENV['ELASTICSEARCH_URL']
        ENV['ELASTICSEARCH_URL'] = 'example.com'
        example.run
        ENV['ELASTICSEARCH_URL'] = before_url
      end

      it 'sets the host' do
        expect(client.transport.hosts[0][:host]).to eq('example.com')
        expect(client.transport.hosts.size).to eq(1)
      end
    end

    context 'when mutliple hosts are specified as a comma-separated String list' do

      around do |example|
        before_url = ENV['ELASTICSEARCH_URL']
        ENV['ELASTICSEARCH_URL'] = 'example.com, other.com'
        example.run
        ENV['ELASTICSEARCH_URL'] = before_url
      end

      it 'sets the hosts' do
        expect(client.transport.hosts[0][:host]).to eq('example.com')
        expect(client.transport.hosts[1][:host]).to eq('other.com')
        expect(client.transport.hosts.size).to eq(2)
      end
    end
  end

  context 'when options are defined' do

    context 'when scheme is specified' do

      let(:client) do
        described_class.new(scheme: 'https')
      end

      it 'sets the scheme' do
        expect(client.transport.connections[0].full_url('')).to match(/https/)
      end
    end

    context 'when user and password are specified' do

      let(:client) do
        described_class.new(user: 'USERNAME', password: 'PASSWORD')
      end

      it 'sets the user and password' do
        expect(client.transport.connections[0].full_url('')).to match(/USERNAME/)
        expect(client.transport.connections[0].full_url('')).to match(/PASSWORD/)
      end

      context 'when the connections are reloaded' do

        before do
          allow(client.transport.sniffer).to receive(:hosts).and_return([{ host: 'foobar', port: 4567, id: 'foobar4567' }])
          client.transport.reload_connections!
        end

        it 'sets keeps user and password' do
          expect(client.transport.connections[0].full_url('')).to match(/USERNAME/)
          expect(client.transport.connections[0].full_url('')).to match(/PASSWORD/)
          expect(client.transport.connections[0].full_url('')).to match(/foobar/)
        end
      end
    end

    context 'when port is specified' do

      let(:client) do
        described_class.new(host: 'node1', port: 1234)
      end

      it 'sets the port' do
        expect(client.transport.connections[0].full_url('')).to match(/1234/)
      end
    end

    context 'when the log option is true' do

      let(:client) do
        described_class.new(log: true)
      end

      it 'has a default logger for transport' do
        expect(client.transport.logger.info).to eq(described_class::DEFAULT_LOGGER.call.info)
      end
    end

    context 'when the trace option is true' do

      let(:client) do
        described_class.new(trace: true)
      end

      it 'has a default logger for transport' do
        expect(client.transport.tracer.info).to eq(described_class::DEFAULT_TRACER.call.info)
      end
    end

    context 'when a custom transport class is specified' do

      let(:transport_class) do
        Class.new { def initialize(*); end }
      end

      let(:client) do
        described_class.new(transport_class: transport_class)
      end

      it 'allows the custom transport class to be defined' do
        expect(client.transport).to be_a(transport_class)
      end
    end

    context 'when a custom transport instance is specified' do

      let(:transport_instance) do
        Class.new { def initialize(*); end }.new
      end

      let(:client) do
        described_class.new(transport: transport_instance)
      end

      it 'allows the custom transport class to be defined' do
        expect(client.transport).to be(transport_instance)
      end
    end

    context 'when \'transport_options\' are defined' do

      let(:client) do
        described_class.new(transport_options: { request: { timeout: 1 } })
      end

      it 'sets the options on the transport' do
        expect(client.transport.options[:transport_options][:request]).to eq(timeout: 1)
      end
    end

    context 'when \'request_timeout\' is defined' do

      let(:client) do
        described_class.new(request_timeout: 120)
      end

      it 'sets the options on the transport' do
        expect(client.transport.options[:transport_options][:request]).to eq(timeout: 120)
      end
    end
  end

  describe '#perform_request' do

    let(:transport_instance) do
      Class.new { def initialize(*); end }.new
    end

    let(:client) do
      described_class.new(transport: transport_instance)
    end

    it 'delegates performing requests to the transport' do
      expect(transport_instance).to receive(:perform_request).and_return(true)
      expect(client.perform_request('GET', '/')).to be(true)
    end

    context 'when the \'send_get_body_as\' option is specified' do

      let(:client) do
        described_class.new(transport: transport_instance, :send_get_body_as => 'POST')
      end

      before do
        expect(transport_instance).to receive(:perform_request).with('POST', '/', {},
                                                                     '{"foo":"bar"}',
                                                                     '{"Content-Type":"application/x-ndjson"}').and_return(true)
      end

      let(:request) do
        client.perform_request('POST', '/', {}, '{"foo":"bar"}', '{"Content-Type":"application/x-ndjson"}')
      end

      it 'sets the option' do
        expect(request).to be(true)
      end
    end
  end

  context 'when the client connects to Elasticsearch' do

    let(:logger) do
      Logger.new(STDERR).tap do |logger|
        logger.formatter = proc do |severity, datetime, progname, msg|
          color = case severity
                  when /INFO/ then :green
                  when /ERROR|WARN|FATAL/ then :red
                  when /DEBUG/ then :cyan
                  else :white
                  end
          ANSI.ansi(severity[0] + ' ', color, :faint) + ANSI.ansi(msg, :white, :faint) + "\n"
        end
      end unless ENV['QUIET']
    end

    let(:port) do
      (ENV['TEST_CLUSTER_PORT'] || 9250).to_i
    end

    let(:transport_options) do
      {}
    end

    let(:options) do
      {}
    end

    let(:client) do
      described_class.new({ host: hosts, logger: logger }.merge!(transport_options: transport_options).merge!(options))
    end

    context 'when a request is made' do

      let!(:response) do
        client.perform_request('GET', '_cluster/health')
      end

      it 'connects to the cluster' do
        expect(response.body['number_of_nodes']).to be >(1)
      end
    end

    describe '#initialize' do

      context 'when options are specified' do

        let(:transport_options) do
          { headers: { accept: 'application/yaml', content_type: 'application/yaml' } }
        end

        let(:response) do
          client.perform_request('GET', '_cluster/health')
        end

        it 'applies the options to the client' do
          expect(response.body).to match(/---\n/)
          expect(response.headers['content-type']).to eq('application/yaml')
        end
      end

      context 'when a block is provided' do

        let(:client) do
          Elasticsearch::Client.new(host: ELASTICSEARCH_HOSTS.first, logger: logger) do |client|
            client.headers['Accept'] = 'application/yaml'
          end
        end

        let(:response) do
          client.perform_request('GET', '_cluster/health')
        end

        it 'executes the block' do
          expect(response.body).to match(/---\n/)
          expect(response.headers['content-type']).to eq('application/yaml')
        end

        context 'when the Faraday adapter is set in the block' do

          let(:client) do
            Elasticsearch::Client.new(host: ELASTICSEARCH_HOSTS.first, logger: logger) do |client|
              client.adapter(:net_http_persistent)
            end
          end

          let(:connection_handler) do
            client.transport.connections.first.connection.builder.handlers.first
          end

          let(:response) do
            client.perform_request('GET', '_cluster/health')
          end

          it 'sets the adapter' do
            expect(connection_handler.name).to eq('Faraday::Adapter::NetHttpPersistent')
          end

          it 'uses the adapter to connect' do
            expect(response.status).to eq(200)
          end
        end
      end
    end

    describe '#options' do

      context 'when retry_on_failure is true' do

        context 'when a node is unreachable' do

          let(:hosts) do
            [ELASTICSEARCH_HOSTS.first, "foobar1", "foobar2"]
          end

          let(:options) do
            { retry_on_failure: true }
          end

          let(:responses) do
            5.times.collect do
              client.perform_request('GET', '_nodes/_local')
            end
          end

          it 'retries on failure' do
            expect(responses.all? { true }).to be(true)
          end
        end
      end

      context 'when retry_on_failure is an integer' do

        let(:hosts) do
          [ELASTICSEARCH_HOSTS.first, 'foobar1', 'foobar2', 'foobar3']
        end

        let(:options) do
          { retry_on_failure: 1 }
        end

        it 'retries only the specified number of times' do
          expect(client.perform_request('GET', '_nodes/_local'))
          expect {
            client.perform_request('GET', '_nodes/_local')
          }.to raise_exception(Faraday::Error::ConnectionFailed)
        end
      end

      context 'when reload_on_failure is true' do

        let(:hosts) do
          [ELASTICSEARCH_HOSTS.first, 'foobar1', 'foobar2']
        end

        let(:options) do
          { reload_on_failure: true }
        end

        let(:responses) do
          5.times.collect do
            client.perform_request('GET', '_nodes/_local')
          end
        end

        it 'reloads the connections' do
          expect(client.transport.connections.size).to eq(3)
          expect(responses.all? { true }).to be(true)
          expect(client.transport.connections.size).to eq(2)
        end
      end

      context 'when retry_on_status is specified' do

        let(:options) do
          { retry_on_status: 400 }
        end

        let(:logger) do
          double('logger', :fatal => false)
        end

        before do
          expect(logger).to receive(:warn).exactly(4).times
        end

        it 'retries when the status matches' do
          expect {
            client.perform_request('PUT', '_foobar')
          }.to raise_exception(Elasticsearch::Transport::Transport::Errors::BadRequest)
        end
      end
    end

    describe '#perform_request' do

      context 'when a request is made' do

        before do
          client.perform_request('DELETE', '_all')
          client.perform_request('DELETE', 'myindex') rescue
              client.perform_request('PUT', 'myindex', {}, { settings: { number_of_shards: 10 } })
          client.perform_request('PUT', 'myindex/mydoc/1', { routing: 'XYZ', timeout: '1s' }, { foo: 'bar' })
          client.perform_request('GET', '_cluster/health?wait_for_status=green', {})
        end

        let(:response) do
          client.perform_request('GET', 'myindex/mydoc/1?routing=XYZ')
        end

        it 'handles paths and URL paramters' do
          expect(response.status).to eq(200)
        end

        it 'returns response body' do
          expect(response.body['_source']).to eq('foo' => 'bar')
        end
      end

      context 'when an invalid url is specified' do

        it 'raises an exception' do
          expect {
            client.perform_request('GET', 'myindex/mydoc/1?routing=FOOBARBAZ')
          }.to raise_exception(Elasticsearch::Transport::Transport::Errors::NotFound)
        end
      end

      context 'when the \'ignore\' parameter is specified' do

        let(:response) do
          client.perform_request('PUT', '_foobar', ignore: 400)
        end

        it 'exposes the status in the response' do
          expect(response.status).to eq(400)
        end

        it 'exposes the body of the response' do
          expect(response.body).to be_a(Hash)
          expect(response.body.inspect).to match(/invalid_index_name_exception/)
        end
      end

      context 'when request headers are specified' do

        let(:response) do
          client.perform_request('GET', '/', {}, nil, { 'Content-Type' => 'application/yaml' })
        end

        it 'passes them to the transport' do
          expect(response.body).to match(/---/)
        end
      end

      describe 'selector' do

        context 'when the round-robin selector is used' do

          let(:nodes) do
            3.times.collect do
              client.perform_request('GET', '_nodes/_local').body['nodes'].to_a[0][1]['name']
            end
          end

          let(:node_names) do
            client.nodes.stats['nodes'].collect do |name, stats|
              stats['name']
            end
          end

          let(:expected_names) do
            3.times.collect do |i|
              node_names[i % node_names.size]
            end
          end

          # it 'rotates nodes' do
          #   pending 'Better way to detect rotating nodes'
          #   expect(nodes).to eq(expected_names)
          # end
        end
      end

      context 'when patron is used as an adapter', unless: jruby? do

        before do
          require 'patron'
        end

        let(:options) do
          { adapter: :patron }
        end

        let(:connection_handler) do
          client.transport.connections.first.connection.builder.handlers.first
        end

        it 'uses the patron connection handler' do
          expect(connection_handler).to eq('Faraday::Adapter::Patron')
        end

        it 'keeps connections open' do
          response = client.perform_request('GET', '_nodes/stats/http')
          connections_before = response.body['nodes'].values.find { |n| n['name'] == node_names.first }['http']['total_opened']
          client.transport.reload_connections!
          response = client.perform_request('GET', '_nodes/stats/http')
          connections_after = response.body['nodes'].values.find { |n| n['name'] == node_names.first }['http']['total_opened']
          expect(connections_after).to be >= (connections_before)
        end
      end
    end
  end
end
