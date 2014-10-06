require_relative '../test_helper'

if !JRUBY
  puts "'#{File.basename(__FILE__)}' only supported on JRuby (you're running #{RUBY_VERSION})"
else
  require 'elasticsearch/transport/transport/http/manticore'
  require 'manticore'

  class Elasticsearch::Transport::Transport::HTTP::ManticoreTest < Test::Unit::TestCase
    include Elasticsearch::Transport::Transport::HTTP

    context "Manticore transport" do
      setup do
        @transport = Manticore.new :hosts => [ { :host => '127.0.0.1', :port => 8080 } ]
      end

      should "implement host_unreachable_exceptions" do
        assert_instance_of Array, @transport.host_unreachable_exceptions
      end

      should "implement __build_connections" do
        assert_equal 1, @transport.hosts.size
        assert_equal 1, @transport.connections.size

        assert_instance_of ::Manticore::Client,   @transport.connections.first.connection
      end

      should "perform the request" do
        @transport.connections.first.connection.expects(:get).returns(stub_everything)
        @transport.perform_request 'GET', '/'
      end

      should "set body for GET request" do
        @transport.connections.first.connection.expects(:get).
          with('http://127.0.0.1:8080//', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.perform_request 'GET', '/', {}, '{"foo":"bar"}'
      end

      should "set body for PUT request" do
        @transport.connections.first.connection.expects(:put).
          with('http://127.0.0.1:8080//', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.perform_request 'PUT', '/', {}, {:foo => 'bar'}
      end

      should "serialize the request body" do
        @transport.connections.first.connection.expects(:post).
          with('http://127.0.0.1:8080//', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.perform_request 'POST', '/', {}, {'foo' => 'bar'}
      end

      should "not serialize a String request body" do
        @transport.connections.first.connection.expects(:post).
          with('http://127.0.0.1:8080//', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.serializer.expects(:dump).never
        @transport.perform_request 'POST', '/', {}, '{"foo":"bar"}'
      end

      should "set application/json header" do
        @transport.connections.first.connection.stub("http://127.0.0.1:8080", body: '{"foo":"bar"}', headers: {"X-Content-Type" => "application/json"}, code: 200 )
        #@transport.connections.first.connection.expects(:get).returns(stub_everything)

        response = @transport.perform_request 'GET', '/', { :headers => {"X-Content-Type" => "application/json"} } 

        assert_equal 'application/json', response.headers['content-type']
      end

      should "handle HTTP methods" do
        @transport.connections.first.connection.expects(:delete).with('http://127.0.0.1:8080//', {}).returns(stub_everything)
        @transport.connections.first.connection.expects(:head).with('http://127.0.0.1:8080//', {}).returns(stub_everything)
        @transport.connections.first.connection.expects(:get).with('http://127.0.0.1:8080//', {}).returns(stub_everything)
        @transport.connections.first.connection.expects(:put).with('http://127.0.0.1:8080//', {}).returns(stub_everything)
        @transport.connections.first.connection.expects(:post).with('http://127.0.0.1:8080//', {}).returns(stub_everything)

        %w| HEAD GET PUT POST DELETE |.each { |method| @transport.perform_request method, '/' }

        assert_raise(ArgumentError) { @transport.perform_request 'FOOBAR', '/' }
      end

      should "allow to set options for Manticore" do
        transport = Manticore.new :hosts => [ { :host => 'foobar', :port => 1234 } ] do |manticore|
          manticore.headers["User-Agent"] = "myapp-0.0"
        end

        assert_equal "myapp-0.0", transport.connections.first.connection.headers["User-Agent"]
      end

      should "set the credentials if passed" do
        transport = Manticore.new :hosts => [ { :host => 'foobar', :port => 1234, :user => 'foo', :password => 'bar' } ]
        assert_equal 'foo', transport.connections.first.connection.username
        assert_equal 'bar', transport.connections.first.connection.password
      end
    end

  end

end
