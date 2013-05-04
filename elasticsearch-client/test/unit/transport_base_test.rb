require 'test_helper'

class Elasticsearch::Client::Transport::BaseTest < Test::Unit::TestCase

  class EmptyTransport
    include Elasticsearch::Client::Transport::Base
  end

  class DummyTransport
    include Elasticsearch::Client::Transport::Base
    def __build_connections; hosts; end
  end

  class DummyTransportPerformer < DummyTransport
    def perform_request(method, path, params={}, body=nil, &block); super; end
  end

  class DummySerializer
    def initialize(*); end
  end

  class DummySniffer
    def initialize(*); end
  end

  context "Transport::Base" do
    should "raise exception when it doesn't implement __build_connections" do
      assert_raise NoMethodError do
        EmptyTransport.new.__build_connections
      end
    end

    should "build connections on initialization" do
      DummyTransport.any_instance.expects(:__build_connections)
      transport = DummyTransport.new
    end

    should "have default serializer" do
      transport = DummyTransport.new
      assert_instance_of Elasticsearch::Client::Transport::Base::DEFAULT_SERIALIZER_CLASS, transport.serializer
    end

    should "have custom serializer" do
      transport = DummyTransport.new :options => { :serializer_class => DummySerializer }
      assert_instance_of DummySerializer, transport.serializer

      transport = DummyTransport.new :options => { :serializer => DummySerializer.new }
      assert_instance_of DummySerializer, transport.serializer
    end

    should "have default sniffer" do
      transport = DummyTransport.new
      assert_instance_of Elasticsearch::Client::Transport::Sniffer, transport.sniffer
    end

    should "have custom sniffer" do
      transport = DummyTransport.new :options => { :sniffer_class => DummySniffer }
      assert_instance_of DummySniffer, transport.sniffer
    end
  end

  context "getting a connection" do
    setup do
      @transport = DummyTransportPerformer.new :options => { :reload_connections => 5 }
      @transport.stubs(:connections).returns(stub :get_connection => Object.new)
      @transport.stubs(:sniffer).returns(stub :hosts => [])
    end

    should "get a connection" do
      assert_not_nil @transport.get_connection
    end

    should "increment the counter" do
      assert_equal 0, @transport.counter
      3.times { @transport.get_connection }
      assert_equal 3, @transport.counter
    end

    should "reload connections when it hits the threshold" do
      @transport.expects(:reload_connections!).twice
      12.times { @transport.get_connection }
      assert_equal 12, @transport.counter
    end
  end

  context "performing a request" do
    setup do
      @transport = DummyTransportPerformer.new
    end

    should "raise an error when no block is passed" do
      assert_raise NoMethodError do
        @transport.peform_request 'GET', '/'
      end
    end

    should "get the connection" do
      @transport.expects(:get_connection).returns(stub_everything)
      @transport.perform_request 'GET', '/' do; Elasticsearch::Client::Transport::Response.new 200, 'OK'; end
    end

    should "raise an error when no connection is available" do
      @transport.expects(:get_connection).returns(nil)
      assert_raise Elasticsearch::Client::Transport::Error do
        @transport.perform_request 'GET', '/' do; Elasticsearch::Client::Transport::Response.new 200, 'OK'; end
      end
    end

    should "call the passed block" do
      x = 0
      @transport.expects(:get_connection).returns(stub_everything)

      @transport.perform_request 'GET', '/' do |connection, url|
        x += 1
        Elasticsearch::Client::Transport::Response.new 200, 'OK'
      end

      assert_equal 1, x
    end

    should "deserialize a JSON body" do
      @transport.expects(:get_connection).returns(stub_everything)
      @transport.serializer.expects(:load).returns({'foo' => 'bar'})

      response = @transport.perform_request 'GET', '/' do
                   Elasticsearch::Client::Transport::Response.new 200, '{"foo":"bar"}'
                 end

      assert_instance_of Elasticsearch::Client::Transport::Response, response
      assert_equal 'bar', response.body['foo']
    end

    should "not deserialize a string body" do
      @transport.expects(:get_connection).returns(stub_everything)
      @transport.serializer.expects(:load).never
      response = @transport.perform_request 'GET', '/' do
                   Elasticsearch::Client::Transport::Response.new 200, 'FOOBAR'
                 end

      assert_instance_of Elasticsearch::Client::Transport::Response, response
      assert_equal 'FOOBAR', response.body
    end

    should "raise an error on server failure" do
      @transport.expects(:get_connection).returns(stub_everything)
      assert_raise Elasticsearch::Client::Transport::ServerError do
        @transport.perform_request 'GET', '/' do
          Elasticsearch::Client::Transport::Response.new 500, 'ERROR'
        end
      end
    end

    should "raise an error on connection failure" do
      @transport.expects(:get_connection).returns(stub_everything)

      # `block.expects(:call).raises(::Errno::ECONNREFUSED)` fails on Ruby 1.8
      block = lambda { |a, b| raise ::Errno::ECONNREFUSED }

      assert_raise ::Errno::ECONNREFUSED do
        @transport.perform_request 'GET', '/', &block
      end
    end
  end

  context "performing a request with reload connections on connection failures" do
    setup do
      fake_collection = stub_everything :get_connection => stub_everything, :all => stub_everything(:size => 2)
      @transport = DummyTransportPerformer.new :options => { :reload_on_failure => 2 }
      @transport.stubs(:connections).
                 returns(fake_collection)
      @block = lambda { |c, u| puts "UNREACHABLE" }
    end

    should "reload connections when host is unreachable" do
      @block.expects(:call).times(2).
            raises(Errno::ECONNREFUSED).
            then.returns(stub_everything)

      @transport.expects(:reload_connections!).returns([])

      @transport.perform_request('GET', '/', &@block)
      assert_equal 2, @transport.counter
    end
  end unless RUBY_1_8

  context "performing a request with retry on connection failures" do
    setup do
      @transport = DummyTransportPerformer.new :options => { :retry_on_failure => true }
      @transport.stubs(:connections).returns(stub :get_connection => stub_everything)
      @block = Proc.new { |c, u| puts "UNREACHABLE" }
    end

    should "retry DEFAULT_MAX_TRIES when host is unreachable" do
      @block.expects(:call).times(3).
            raises(Errno::ECONNREFUSED).
            then.raises(Errno::ECONNREFUSED).
            then.returns(stub_everything)

      assert_nothing_raised do
        @transport.perform_request('GET', '/', &@block)
        assert_equal 3, @transport.counter
      end
    end

    should "raise an error after max tries" do
      @block.expects(:call).times(3).
            raises(Errno::ECONNREFUSED).
            then.raises(Errno::ECONNREFUSED).
            then.raises(Errno::ECONNREFUSED).
            then.raises(Errno::ECONNREFUSED)

      assert_raise Errno::ECONNREFUSED do
        @transport.perform_request('GET', '/', &@block)
      end
    end
  end unless RUBY_1_8

  context "logging" do
    setup do
      @transport = DummyTransportPerformer.new :options => { :logger => Logger.new('/dev/null') }
      @transport.stubs(:get_connection).returns  stub :full_url => 'localhost:9200/_search?size=1', :host => 'localhost'
      @transport.serializer.stubs(:load).returns 'foo' => 'bar'
      @transport.serializer.stubs(:dump).returns '{"foo":"bar"}'
    end

    should "log the request and response" do
      @transport.logger.expects(:info).  with "POST localhost:9200/_search?size=1 [status:200, request:0.000s, query:n/a]"
      @transport.logger.expects(:debug). with '> {"foo":"bar"}'
      @transport.logger.expects(:debug). with '< {"foo":"bar"}'

      @transport.perform_request 'POST', '_search', {:size => 1}, {:foo => 'bar'} do
                   Elasticsearch::Client::Transport::Response.new 200, '{"foo":"bar"}'
                 end
    end

    should "log failed request" do
      @block = Proc.new { |c, u| puts "ERROR" }
      @block.expects(:call).returns(Elasticsearch::Client::Transport::Response.new 500, 'ERROR')

      @transport.logger.expects(:fatal)

      assert_raise Elasticsearch::Client::Transport::ServerError do
        @transport.perform_request('POST', '_search', &@block)
      end
    end unless RUBY_1_8

    should "log and re-raise exception" do
      @block = Proc.new { |c, u| puts "ERROR" }
      @block.expects(:call).raises(Exception)

      @transport.logger.expects(:fatal)

      assert_raise(Exception) { @transport.perform_request('POST', '_search', &@block) }
    end unless RUBY_1_8
  end

  context "tracing" do
    setup do
      @transport = DummyTransportPerformer.new :options => { :tracer => Logger.new('/dev/null') }
      @transport.stubs(:get_connection).returns  stub :full_url => 'localhost:9200/_search'
      @transport.serializer.stubs(:load).returns 'foo' => 'bar'
      @transport.serializer.stubs(:dump).returns <<-JSON.gsub(/^      /, '')
      {
        "foo" : {
          "bar" : {
            "bam" : true
          }
        }
      }
      JSON
    end

    should "trace the request" do
      @transport.tracer.expects(:info).  with do |message|
        message == <<-CURL.gsub(/^            /, '')
            curl -X POST 'http://localhost:9200/_search?pretty&size=1' -d '{
              "foo" : {
                "bar" : {
                  "bam" : true
                }
              }
            }
            '
          CURL
      end.once

      @transport.perform_request 'POST', '_search', {:size => 1}, {:q => 'foo'} do
                   Elasticsearch::Client::Transport::Response.new 200, '{"foo":"bar"}'
                 end
    end

  end

  context "reloading connections" do
    setup do
      @transport = DummyTransport.new :options => { :logger => Logger.new('/dev/null') }
    end

    should "rebuild connections" do
      @transport.sniffer.expects(:hosts).returns([])
      @transport.expects(:__rebuild_connections)
      @transport.reload_connections!
    end

    should "log error and continue when timing out while sniffing hosts" do
      @transport.sniffer.expects(:hosts).raises(Elasticsearch::Client::Transport::SnifferTimeoutError)
      @transport.logger.expects(:error)
      assert_nothing_raised do
        @transport.reload_connections!
      end
    end
  end

  context "rebuilding connections" do
    setup do
      @transport = DummyTransport.new
    end

    should "should replace the connections" do
      assert_equal [], @transport.connections
      @transport.__rebuild_connections :hosts => ['foo', 'bar']
      assert_equal ['foo', 'bar'], @transport.connections
    end
  end

end
