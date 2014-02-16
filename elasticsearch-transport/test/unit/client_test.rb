require 'test_helper'

class Elasticsearch::Transport::ClientTest < Test::Unit::TestCase

  class DummyTransport
    def initialize(*); end
  end

  context "Client" do
    setup do
      Elasticsearch::Transport::Client::DEFAULT_TRANSPORT_CLASS.any_instance.stubs(:__build_connections)
      @client = Elasticsearch::Transport::Client.new
    end

    should "be aliased as Elasticsearch::Client" do
      assert_nothing_raised do
        assert_instance_of(Elasticsearch::Transport::Client, Elasticsearch::Client.new)
      end
    end

    should "have default transport" do
      assert_instance_of Elasticsearch::Transport::Client::DEFAULT_TRANSPORT_CLASS, @client.transport
    end

    should "instantiate custom transport class" do
      client = Elasticsearch::Transport::Client.new :transport_class => DummyTransport
      assert_instance_of DummyTransport, client.transport
    end

    should "take custom transport instance" do
      client = Elasticsearch::Transport::Client.new :transport => DummyTransport.new
      assert_instance_of DummyTransport, client.transport
    end

    should "delegate performing requests to transport" do
      assert_respond_to @client, :perform_request
      @client.transport.expects(:perform_request)
      @client.perform_request 'GET', '/'
    end

    should "have default logger for transport" do
      client = Elasticsearch::Transport::Client.new :log => true
      assert_respond_to client.transport.logger, :info
    end

    should "have default tracer for transport" do
      client = Elasticsearch::Transport::Client.new :trace => true
      assert_respond_to client.transport.tracer, :info
    end

    should "initialize the default transport class" do
      Elasticsearch::Transport::Client::DEFAULT_TRANSPORT_CLASS.any_instance.
        unstub(:__build_connections)

      client = Elasticsearch::Client.new
      assert_match /Faraday/, client.transport.connections.first.connection.headers['User-Agent']
    end

    context "when passed hosts" do
      should "have localhost by default" do
        c = Elasticsearch::Transport::Client.new
        assert_equal 'localhost', c.transport.hosts.first[:host]
      end

      should "take :hosts, :host or :url" do
        c1 = Elasticsearch::Transport::Client.new :hosts => ['foobar']
        c2 = Elasticsearch::Transport::Client.new :host  => 'foobar'
        c3 = Elasticsearch::Transport::Client.new :url   => 'foobar'
        assert_equal 'foobar', c1.transport.hosts.first[:host]
        assert_equal 'foobar', c2.transport.hosts.first[:host]
        assert_equal 'foobar', c3.transport.hosts.first[:host]
      end
    end

    context "extracting hosts" do
      should "handle defaults" do
        hosts = @client.__extract_hosts

        assert_equal 'localhost', hosts[0][:host]
        assert_nil                hosts[0][:port]
      end

      should "extract from string" do
        hosts = @client.__extract_hosts 'myhost'

        assert_equal 'myhost', hosts[0][:host]
        assert_nil             hosts[0][:port]
      end

      should "extract from array" do
        hosts = @client.__extract_hosts ['myhost']

        assert_equal 'myhost', hosts[0][:host]
      end

      should "extract from array with multiple hosts" do
        hosts = @client.__extract_hosts ['host1', 'host2']

        assert_equal 'host1', hosts[0][:host]
        assert_equal 'host2', hosts[1][:host]
      end

      should "extract from array with ports" do
        hosts = @client.__extract_hosts ['host1:1000', 'host2:2000']

        assert_equal 'host1', hosts[0][:host]
        assert_equal '1000',  hosts[0][:port]

        assert_equal 'host2', hosts[1][:host]
        assert_equal '2000',  hosts[1][:port]
      end

      should "extract path" do
        hosts = @client.__extract_hosts 'https://myhost:8080/api'

        assert_equal '/api',  hosts[0][:path]
      end

      should "extract scheme (protocol)" do
        hosts = @client.__extract_hosts 'https://myhost:8080'

        assert_equal 'https',  hosts[0][:scheme]
        assert_equal 'myhost', hosts[0][:host]
        assert_equal '8080',   hosts[0][:port]
      end

      should "extract credentials" do
        hosts = @client.__extract_hosts 'http://USERNAME:PASSWORD@myhost:8080'

        assert_equal 'http',     hosts[0][:scheme]
        assert_equal 'USERNAME', hosts[0][:user]
        assert_equal 'PASSWORD', hosts[0][:password]
        assert_equal 'myhost',   hosts[0][:host]
        assert_equal '8080',     hosts[0][:port]
      end

      should "pass Hashes over" do
        hosts = @client.__extract_hosts [{:host => 'myhost', :port => '1000', :foo => 'bar'}]

        assert_equal 'myhost', hosts[0][:host]
        assert_equal '1000',   hosts[0][:port]
        assert_equal 'bar',    hosts[0][:foo]
      end

      should "use URL instance" do
        require 'uri'
        hosts = @client.__extract_hosts URI.parse('https://USERNAME:PASSWORD@myhost:4430')

        assert_equal 'https',    hosts[0][:scheme]
        assert_equal 'USERNAME', hosts[0][:user]
        assert_equal 'PASSWORD', hosts[0][:password]
        assert_equal 'myhost',   hosts[0][:host]
        assert_equal '4430',     hosts[0][:port]
      end

      should "raise error for incompatible argument" do
        assert_raise ArgumentError do
          @client.__extract_hosts 123
        end
      end

      should "randomize hosts" do
        hosts = [ {:host => 'host1'}, {:host => 'host2'}, {:host => 'host3'}, {:host => 'host4'}, {:host => 'host5'}]

        Array.any_instance.expects(:shuffle!).twice

        @client.__extract_hosts(hosts, :randomize_hosts => true)
        assert_same_elements hosts, @client.__extract_hosts(hosts, :randomize_hosts => true)
      end
    end

    context "detecting adapter for Faraday" do
      setup do
        Elasticsearch::Transport::Client::DEFAULT_TRANSPORT_CLASS.any_instance.unstub(:__build_connections)
        begin; Object.send(:remove_const, :Typhoeus); rescue NameError; end
        begin; Object.send(:remove_const, :Patron);   rescue NameError; end
      end

      should "use the default adapter" do
        c = Elasticsearch::Transport::Client.new
        handlers = c.transport.connections.all.first.connection.builder.handlers

        assert_includes handlers, Faraday::Adapter::NetHttp
      end

      should "use the adapter from arguments" do
        c = Elasticsearch::Transport::Client.new :adapter => :typhoeus
        handlers = c.transport.connections.all.first.connection.builder.handlers

        assert_includes handlers, Faraday::Adapter::Typhoeus
      end

      should "detect the adapter" do
        require 'patron'
        c = Elasticsearch::Transport::Client.new
        handlers = c.transport.connections.all.first.connection.builder.handlers

        assert_includes handlers, Faraday::Adapter::Patron
      end
    end

  end
end
