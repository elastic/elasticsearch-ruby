require 'test_helper'
require 'elasticsearch/client/transport/http/curb'
require 'curb'

class Elasticsearch::Client::Transport::HTTP::FaradayTest < Test::Unit::TestCase
  include Elasticsearch::Client::Transport::HTTP

  context "Curb transport" do
    setup do
      @transport = Curb.new :hosts => [ { :host => 'foobar', :port => 1234 } ]
    end

    should "implement __build_connections" do
      assert_equal 1, @transport.hosts.size
      assert_equal 1, @transport.connections.size

      assert_instance_of ::Curl::Easy, @transport.connections.first.connection
      assert_equal 'http://foobar:1234', @transport.connections.first.connection.url
    end

    should "perform the request" do
      @transport.connections.first.connection.expects(:http).returns(stub_everything)
      @transport.perform_request 'GET', '/'
    end

    should "handle HTTP methods" do
      @transport.connections.first.connection.expects(:http).twice.returns(stub_everything)
      @transport.connections.first.connection.expects(:http_put).returns(stub_everything)
      @transport.connections.first.connection.expects(:http_post).returns(stub_everything)
      @transport.connections.first.connection.expects(:http_delete).returns(stub_everything)

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
  end

end
