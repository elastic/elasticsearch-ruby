require 'test_helper'

class Elasticsearch::Transport::ClientIntegrationTest < Elasticsearch::Test::IntegrationTestCase
  startup do
    Elasticsearch::TestCluster.start if ENV['SERVER'] and not Elasticsearch::TestCluster.running?
  end

  context "Elasticsearch client" do
    setup do
      system "curl -X DELETE http://localhost:9250/_all > /dev/null 2>&1"

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

      @client = Elasticsearch::Client.new host: 'localhost:9250'
    end

    should "connect to the cluster" do
      assert_nothing_raised do
        response = @client.perform_request 'GET', '_cluster/health'
        assert_equal 2, response.body['number_of_nodes']
      end
    end

    should "handle paths and URL parameters" do
      @client.perform_request 'PUT', 'myindex/mydoc/1', {routing: 'XYZ'}, {foo: 'bar'}
      response = @client.perform_request 'GET', 'myindex/mydoc/1?routing=XYZ'
      assert_equal true, response.body['exists']
      assert_equal 'bar', response.body['_source']['foo']
      assert_raise Elasticsearch::Transport::Transport::Errors::NotFound do
        response = @client.perform_request 'GET', 'myindex/mydoc/1?routing=ABC'
        assert_nil response.body['_source']
        assert_equal false, response.body['exists']
      end
    end

    context "with round robin selector" do
      setup do
        @client = Elasticsearch::Client.new \
                    hosts: %w| localhost:9250 localhost:9251 |,
                    logger: @logger
      end

      should "rotate nodes" do
        # Hit node 1
        response = @client.perform_request 'GET', '_cluster/nodes/_local'
        assert_equal 'node-1', response.body['nodes'].to_a[0][1]['name']

        # Hit node 2
        response = @client.perform_request 'GET', '_cluster/nodes/_local'
        assert_equal 'node-2', response.body['nodes'].to_a[0][1]['name']

        # Hit node 1
        response = @client.perform_request 'GET', '_cluster/nodes/_local'
        assert_equal 'node-1', response.body['nodes'].to_a[0][1]['name']
      end
    end

    context "with a sick node and retry on failure" do
      setup do
        @client = Elasticsearch::Client.new \
                    hosts: %w| localhost:9250 foobar1 |,
                    logger: @logger,
                    retry_on_failure: true
      end

      should "retry the request with next server" do
        assert_nothing_raised do
          5.times { @client.perform_request 'GET', '_cluster/nodes/_local' }
        end
      end

      should "raise exception when it cannot get any healthy server" do
        @client = Elasticsearch::Client.new \
                  hosts: %w| localhost:9250 foobar1 foobar2 foobar3 |,
                  logger: @logger,
                  retry_on_failure: 1

        assert_nothing_raised do
          # First hit is OK
          @client.perform_request 'GET', '_cluster/nodes/_local'
        end

        assert_raise Faraday::Error::ConnectionFailed do
          # Second hit fails
          @client.perform_request 'GET', '_cluster/nodes/_local'
        end
      end
    end

    context "with a sick node and reloading on failure" do
      setup do
        @client = Elasticsearch::Client.new \
                  hosts: %w| localhost:9250 foobar1 foobar2 |,
                  logger: @logger,
                  reload_on_failure: true
      end

      should "reload the connections" do
        assert_equal 3, @client.transport.connections.size
        assert_nothing_raised do
          5.times { @client.perform_request 'GET', '_cluster/nodes/_local' }
        end
        assert_equal 2, @client.transport.connections.size
      end
    end

  end
end
