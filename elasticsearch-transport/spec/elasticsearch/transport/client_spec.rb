require 'spec_helper'

describe Elasticsearch::Client do

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
    Elasticsearch::Client.new({ host: hosts, logger: logger }.merge!(transport_options: transport_options).merge!(options))
  end

  context 'when a request is made' do

    let!(:response) do
      client.perform_request('GET', '_cluster/health')
    end

    it 'connects to the cluster' do
      expect(response.body['number_of_nodes']).to eq(ELASTICSEARCH_HOSTS.size)
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
        double('logger', :debug? => false, :warn? => true, :fatal? => false)
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

        let(:hosts) do
          ELASTICSEARCH_HOSTS
        end

        let(:nodes) do
          3.times.collect do
            client.perform_request('GET', '_nodes/_local').body['nodes'].to_a[0][1]['name']
          end
        end

        it 'rotates nodes' do
          expect(nodes).to eq(['node-1', 'node-2', 'node-1'])
        end
      end

      context 'when the round-robin selector is used' do

        let(:hosts) do
          ELASTICSEARCH_HOSTS
        end

        let(:nodes) do
          3.times.collect do
            client.perform_request('GET', '_nodes/_local').body['nodes'].to_a[0][1]['name']
          end
        end

        it 'rotates nodes' do
          expect(nodes).to eq(['node-1', 'node-2', 'node-1'])
        end
      end
    end

    context 'when patron is used as an adapter', unless: jruby? do

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
        connections_before = response.body['nodes'].values.select { |n| n['name'] == 'node-1' }.first['http']['total_opened']
        client.transport.reload_connections!
        response = client.perform_request('GET', '_nodes/stats/http')
        connections_after = response.body['nodes'].values.select { |n| n['name'] == 'node-1' }.first['http']['total_opened']
        expect(connections_after).to be >= (connections_before)
      end
    end
  end
end