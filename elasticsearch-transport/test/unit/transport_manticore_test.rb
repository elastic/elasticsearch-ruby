require 'test_helper'

unless JRUBY
  version = ( defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'Ruby' ) + ' ' + RUBY_VERSION
  puts "SKIP: '#{File.basename(__FILE__)}' only supported on JRuby (you're running #{version})"
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
        options = {
          :headers => { "content-type" => "application/json"}
        }

        transport = Manticore.new :hosts => [ { :host => 'localhost', :port => 8080 } ], :options => options

        transport.connections.first.connection.stub("http://localhost:8080//", :body => "\"\"", :headers => {"content-type" => "application/json"}, :code => 200 )

        response = transport.perform_request 'GET', '/', {}
        assert_equal response.status, 200
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
        options = { :headers => {"User-Agent" => "myapp-0.0" }}
        transport = Manticore.new :hosts => [ { :host => 'foobar', :port => 1234 } ], :options => options
        transport.connections.first.connection.expects(:get).
          with('http://foobar:1234//', options).returns(stub_everything)

        transport.perform_request 'GET', '/', {}
      end

      should "allow to set ssl options for Manticore" do
        options = {
          :ssl => {
            :truststore => "test.jks",
            :truststore_password => "test",
            :verify => false
          }
        }

        ::Manticore::Client.expects(:new).with(options)
        transport = Manticore.new :hosts => [ { :host => 'foobar', :port => 1234 } ], :options => options
      end

      should "pass :transport_options to Manticore::Client" do
        options = {
          :transport_options => { :potatoes => 1 }
        }

        ::Manticore::Client.expects(:new).with(:potatoes => 1, :ssl => {})
        transport = Manticore.new :hosts => [ { :host => 'foobar', :port => 1234 } ], :options => options
      end
    end

  end

end
