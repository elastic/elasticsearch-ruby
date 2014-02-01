if JRUBY
  puts "'#{File.basename(__FILE__)}' not supported on JRuby #{RUBY_VERSION}"
  exit(0)
end


require 'test_helper'
require 'elasticsearch/transport/transport/http/curb'
require 'curb'

class Elasticsearch::Transport::Transport::HTTP::FaradayTest < Test::Unit::TestCase
  include Elasticsearch::Transport::Transport::HTTP

  context "Curb transport" do
    setup do
      @transport = Curb.new :hosts => [ { :host => 'foobar', :port => 1234 } ]
    end

    should "implement __build_connections" do
      assert_equal 1, @transport.hosts.size
      assert_equal 1, @transport.connections.size

      assert_instance_of ::Curl::Easy,   @transport.connections.first.connection
      assert_equal 'http://foobar:1234', @transport.connections.first.connection.url
    end

    should "perform the request" do
      @transport.connections.first.connection.expects(:http).returns(stub_everything)
      @transport.perform_request 'GET', '/'
    end

    should "set body for GET request" do
      @transport.connections.first.connection.expects(:put_data=).with('{"foo":"bar"}')
      @transport.connections.first.connection.expects(:http).with(:GET).returns(stub_everything)
      @transport.perform_request 'GET', '/', {}, '{"foo":"bar"}'
    end

    should "set body for PUT request" do
      @transport.connections.first.connection.expects(:put_data=)
      @transport.connections.first.connection.expects(:http).with(:PUT).returns(stub_everything)
      @transport.perform_request 'PUT', '/', {}, {:foo => 'bar'}
    end

    should "serialize the request body" do
      @transport.connections.first.connection.expects(:http).with(:POST).returns(stub_everything)
      @transport.serializer.expects(:dump)
      @transport.perform_request 'POST', '/', {}, {:foo => 'bar'}
    end

    should "not serialize a String request body" do
      @transport.connections.first.connection.expects(:http).with(:POST).returns(stub_everything)
      @transport.serializer.expects(:dump).never
      @transport.perform_request 'POST', '/', {}, '{"foo":"bar"}'
    end

    should "handle HTTP methods" do
      @transport.connections.first.connection.expects(:http).with(:HEAD).returns(stub_everything)
      @transport.connections.first.connection.expects(:http).with(:GET).returns(stub_everything)
      @transport.connections.first.connection.expects(:http).with(:PUT).returns(stub_everything)
      @transport.connections.first.connection.expects(:http).with(:POST).returns(stub_everything)
      @transport.connections.first.connection.expects(:http).with(:DELETE).returns(stub_everything)

      %w| HEAD GET PUT POST DELETE |.each { |method| @transport.perform_request method, '/' }

      assert_raise(ArgumentError) { @transport.perform_request 'FOOBAR', '/' }
    end

    should "allow to set options for Curb" do
      transport = Curb.new :hosts => [ { :host => 'foobar', :port => 1234 } ] do |curl|
        curl.headers["User-Agent"] = "myapp-0.0"
      end

      assert_equal( {"Content-Type"=>"application/json", "User-Agent"=>"myapp-0.0"},
                    transport.connections.first.connection.headers )
    end

    should "set the credentials if passed" do
      transport = Curb.new :hosts => [ { :host => 'foobar', :port => 1234, :user => 'foo', :password => 'bar' } ]
      assert_equal 'foo', transport.connections.first.connection.username
      assert_equal 'bar', transport.connections.first.connection.password
    end
  end

end
