require 'test_helper'

class Elasticsearch::Transport::Transport::BaseTest < Test::Unit::TestCase

  class EmptyTransport
    include Elasticsearch::Transport::Transport::Base
  end

  class DummyTransport
    include Elasticsearch::Transport::Transport::Base
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
      assert_instance_of Elasticsearch::Transport::Transport::Base::DEFAULT_SERIALIZER_CLASS, transport.serializer
    end

    should "have custom serializer" do
      transport = DummyTransport.new :options => { :serializer_class => DummySerializer }
      assert_instance_of DummySerializer, transport.serializer

      transport = DummyTransport.new :options => { :serializer => DummySerializer.new }
      assert_instance_of DummySerializer, transport.serializer
    end

    should "have default sniffer" do
      transport = DummyTransport.new
      assert_instance_of Elasticsearch::Transport::Transport::Sniffer, transport.sniffer
    end

    should "have custom sniffer" do
      transport = DummyTransport.new :options => { :sniffer_class => DummySniffer }
      assert_instance_of DummySniffer, transport.sniffer
    end

    context "when combining the URL" do
      setup do
        @transport   = DummyTransport.new
        @basic_parts = { :protocol => 'http', :host => 'myhost', :port => 8080 }
      end

      should "combine basic parts" do
        assert_equal 'http://myhost:8080', @transport.__full_url(@basic_parts)
      end

      should "combine path" do
        assert_equal 'http://myhost:8080/api', @transport.__full_url(@basic_parts.merge :path => '/api')
      end

      should "combine authentication credentials" do
        assert_equal 'http://U:P@myhost:8080', @transport.__full_url(@basic_parts.merge :user => 'U', :password => 'P')
      end
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
      @transport.expects(:get_connection).returns(stub_everything :failures => 1)
      @transport.perform_request 'GET', '/' do; Elasticsearch::Transport::Transport::Response.new 200, 'OK'; end
    end

    should "raise an error when no connection is available" do
      @transport.expects(:get_connection).returns(nil)
      assert_raise Elasticsearch::Transport::Transport::Error do
        @transport.perform_request 'GET', '/' do; Elasticsearch::Transport::Transport::Response.new 200, 'OK'; end
      end
    end

    should "call the passed block" do
      x = 0
      @transport.expects(:get_connection).returns(stub_everything :failures => 1)

      @transport.perform_request 'GET', '/' do |connection, url|
        x += 1
        Elasticsearch::Transport::Transport::Response.new 200, 'OK'
      end

      assert_equal 1, x
    end

    should "deserialize a response JSON body" do
      @transport.expects(:get_connection).returns(stub_everything :failures => 1)
      @transport.serializer.expects(:load).returns({'foo' => 'bar'})

      response = @transport.perform_request 'GET', '/' do
                   Elasticsearch::Transport::Transport::Response.new 200, '{"foo":"bar"}', {"content-type" => 'application/json'}
                 end

      assert_instance_of Elasticsearch::Transport::Transport::Response, response
      assert_equal 'bar', response.body['foo']
    end

    should "not deserialize a response string body" do
      @transport.expects(:get_connection).returns(stub_everything :failures => 1)
      @transport.serializer.expects(:load).never
      response = @transport.perform_request 'GET', '/' do
                   Elasticsearch::Transport::Transport::Response.new 200, 'FOOBAR', {"content-type" => 'text/plain'}
                 end

      assert_instance_of Elasticsearch::Transport::Transport::Response, response
      assert_equal 'FOOBAR', response.body
    end

    should "serialize non-String objects" do
      @transport.serializer.expects(:dump).times(3)
      @transport.__convert_to_json({:foo => 'bar'})
      @transport.__convert_to_json([1, 2, 3])
      @transport.__convert_to_json(nil)
    end

    should "not serialize a String object" do
      @transport.serializer.expects(:dump).never
      @transport.__convert_to_json('{"foo":"bar"}')
    end

    should "raise an error for HTTP status 404" do
      @transport.expects(:get_connection).returns(stub_everything :failures => 1)
      assert_raise Elasticsearch::Transport::Transport::Errors::NotFound do
        @transport.perform_request 'GET', '/' do
          Elasticsearch::Transport::Transport::Response.new 404, 'NOT FOUND'
        end
      end
    end

    should "raise an error on server failure" do
      @transport.expects(:get_connection).returns(stub_everything :failures => 1)
      assert_raise Elasticsearch::Transport::Transport::Errors::InternalServerError do
        @transport.perform_request 'GET', '/' do
          Elasticsearch::Transport::Transport::Response.new 500, 'ERROR'
        end
      end
    end

    should "raise an error on connection failure" do
      @transport.expects(:get_connection).returns(stub_everything :failures => 1)

      # `block.expects(:call).raises(::Errno::ECONNREFUSED)` fails on Ruby 1.8
      block = lambda { |a, b| raise ::Errno::ECONNREFUSED }

      assert_raise ::Errno::ECONNREFUSED do
        @transport.perform_request 'GET', '/', &block
      end
    end

    should "mark the connection as dead on failure" do
      c = stub_everything :failures => 1
      @transport.expects(:get_connection).returns(c)

      block = lambda { |a,b| raise ::Errno::ECONNREFUSED }

      c.expects(:dead!)

      assert_raise( ::Errno::ECONNREFUSED ) { @transport.perform_request 'GET', '/', &block }
    end
  end

  context "performing a request with reload connections on connection failures" do
    setup do
      fake_collection = stub_everything :get_connection => stub_everything(:failures => 1),
                                        :all            => stub_everything(:size => 2)
      @transport = DummyTransportPerformer.new :options => { :reload_on_failure => 2 }
      @transport.stubs(:connections).
                 returns(fake_collection)
      @block = lambda { |c, u| puts "UNREACHABLE" }
    end

    should "reload connections when host is unreachable" do
      @block.expects(:call).times(2).
            raises(Errno::ECONNREFUSED).
            then.returns(stub_everything :failures => 1)

      @transport.expects(:reload_connections!).returns([])

      @transport.perform_request('GET', '/', &@block)
      assert_equal 2, @transport.counter
    end
  end unless RUBY_1_8

  context "performing a request with retry on connection failures" do
    setup do
      @transport = DummyTransportPerformer.new :options => { :retry_on_failure => true }
      @transport.stubs(:connections).returns(stub :get_connection => stub_everything(:failures => 1))
      @block = Proc.new { |c, u| puts "UNREACHABLE" }
    end

    should "retry DEFAULT_MAX_TRIES when host is unreachable" do
      @block.expects(:call).times(3).
            raises(Errno::ECONNREFUSED).
            then.raises(Errno::ECONNREFUSED).
            then.returns(stub_everything :failures => 1)

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

      fake_connection = stub :full_url => 'localhost:9200/_search?size=1',
                             :host     => 'localhost',
                             :connection => stub_everything,
                             :failures => 0,
                             :healthy! => true

      @transport.stubs(:get_connection).returns(fake_connection)
      @transport.serializer.stubs(:load).returns 'foo' => 'bar'
      @transport.serializer.stubs(:dump).returns '{"foo":"bar"}'
    end

    should "log the request and response" do
      @transport.logger.expects(:info).  with do |line|
        line =~ %r|POST localhost\:9200/_search\?size=1 \[status\:200, request:.*s, query:n/a\]|
      end
      @transport.logger.expects(:debug). with '> {"foo":"bar"}'
      @transport.logger.expects(:debug). with '< {"foo":"bar"}'

      @transport.perform_request 'POST', '_search', {:size => 1}, {:foo => 'bar'} do
                   Elasticsearch::Transport::Transport::Response.new 200, '{"foo":"bar"}'
                 end
    end

    should "log failed request" do
      @block = Proc.new { |c, u| puts "ERROR" }
      @block.expects(:call).returns(Elasticsearch::Transport::Transport::Response.new 500, 'ERROR')

      @transport.logger.expects(:fatal)

      assert_raise Elasticsearch::Transport::Transport::Errors::InternalServerError do
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

      fake_connection = stub :full_url => 'localhost:9200/_search?size=1',
                             :host     => 'localhost',
                             :connection => stub_everything,
                             :failures => 0,
                             :healthy! => true

      @transport.stubs(:get_connection).returns(fake_connection)
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
                   Elasticsearch::Transport::Transport::Response.new 200, '{"foo":"bar"}'
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
      @transport.sniffer.expects(:hosts).raises(Elasticsearch::Transport::Transport::SnifferTimeoutError)
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

  context "resurrecting connections" do
    setup do
      @transport = DummyTransportPerformer.new
    end

    should "delegate to dead connections" do
      @transport.connections.expects(:dead).returns([])
      @transport.resurrect_dead_connections!
    end

    should "not resurrect connections until timeout" do
      @transport.connections.expects(:get_connection).returns(stub_everything :failures => 1).times(5)
      @transport.expects(:resurrect_dead_connections!).never
      5.times { @transport.get_connection }
    end

    should "resurrect connections after timeout" do
      @transport.connections.expects(:get_connection).returns(stub_everything :failures => 1).times(5)
      @transport.expects(:resurrect_dead_connections!)

      4.times { @transport.get_connection }

      now = Time.now + 60*2
      Time.stubs(:now).returns(now)

      @transport.get_connection
    end

    should "mark connection healthy if it succeeds" do
      c = stub_everything(:failures => 1)
      @transport.expects(:get_connection).returns(c)
      c.expects(:healthy!)

      @transport.perform_request('GET', '/') { |connection, url| Elasticsearch::Transport::Transport::Response.new 200, 'OK' }
    end
  end

end
