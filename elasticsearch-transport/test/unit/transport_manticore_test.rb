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

      should "prevent requests after __close_connections" do
        @transport.__close_connections
        assert_raises ::Manticore::ClientStoppedException do
          @transport.perform_request 'GET', '/'
        end
      end

      should "perform the request" do
        @transport.adapter.manticore.expects(:get).returns(stub_everything)
        @transport.perform_request 'GET', '/'
      end

      should "set body for GET request" do
        @transport.adapter.manticore.expects(:get).
          with('http://127.0.0.1:8080/', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.perform_request 'GET', '/', {}, '{"foo":"bar"}'
      end

      should "set body for PUT request" do
        @transport.adapter.manticore.expects(:put).
          with('http://127.0.0.1:8080/', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.perform_request 'PUT', '/', {}, {:foo => 'bar'}
      end

      should "serialize the request body" do
        @transport.adapter.manticore.expects(:post).
          with('http://127.0.0.1:8080/', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.perform_request 'POST', '/', {}, {'foo' => 'bar'}
      end

      should "not serialize a String request body" do
        @transport.adapter.manticore.expects(:post).
          with('http://127.0.0.1:8080/', {:body => '{"foo":"bar"}'}).returns(stub_everything)
        @transport.serializer.expects(:dump).never
        @transport.perform_request 'POST', '/', {}, '{"foo":"bar"}'
      end

      should "set application/json header" do
        options = {
          :headers => { "content-type" => "application/json"}
        }

        transport = Manticore.new :hosts => [ { :host => 'localhost', :port => 8080 } ], :options => options

        resp = mock()
        resp.stubs(:code).returns(200)
        resp.stubs(:read_body).returns(nil)
        resp.stubs(:headers).returns({})
        transport.adapter.manticore.expects(:get).with("http://localhost:8080/", :headers => {"content-type" => "application/json"}).returns(resp)


        response = transport.perform_request 'GET', '/', {}
        assert_equal response.status, 200
      end

      should "handle HTTP methods" do
        @transport.adapter.manticore.expects(:delete).with('http://127.0.0.1:8080/', {}).returns(stub_everything)
        @transport.adapter.manticore.expects(:head).with('http://127.0.0.1:8080/', {}).returns(stub_everything)
        @transport.adapter.manticore.expects(:get).with('http://127.0.0.1:8080/', {}).returns(stub_everything)
        @transport.adapter.manticore.expects(:put).with('http://127.0.0.1:8080/', {}).returns(stub_everything)
        @transport.adapter.manticore.expects(:post).with('http://127.0.0.1:8080/', {}).returns(stub_everything)

        %w| HEAD GET PUT POST DELETE |.each { |method| @transport.perform_request method, '/' }

        assert_raise(ArgumentError) { @transport.perform_request 'FOOBAR', '/' }
      end

      should "allow to set options for Manticore" do
        options = { :headers => {"User-Agent" => "myapp-0.0" }}
        transport = Manticore.new :hosts => [ { :host => 'foobar', :port => 1234 } ], :options => options
        transport.adapter.manticore.expects(:get).
          with('http://foobar:1234/', options).returns(stub_everything)

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
        Manticore.new :hosts => [ { :host => 'foobar', :port => 1234 } ], :options => options
      end

      should "pass :transport_options to Manticore::Client" do
        options = {
          :transport_options => { :potatoes => 1 }
        }

        ::Manticore::Client.expects(:new).with(:potatoes => 1, :ssl => {})
        Manticore.new :hosts => [ { :host => 'foobar', :port => 1234 } ], :options => options
      end

      context "#with_request_retries" do
        setup do
          @retry_count = 3
          @retry_on_status = 429
          @transport = Manticore.new :hosts => [{:host => 'foobar'}],
                                     :options => {
                                       :retry_on_failure => @retry_count,
                                       :retry_on_status => [429],
                                       :reload_on_failure => true
                                     }
        end

        should "only retry 'tries' times when ServerError exceptions are encountered then raises" do
          count = 0
          resp = ::Elasticsearch::Transport::Transport::Response.new(429, nil, {})
          e = ::Elasticsearch::Transport::Transport::ServerError.new(resp)
          assert_raises e.class do
            @transport.with_request_retries do
              count += 1
              raise e
            end
          end

          # Add one for the orig request
          assert_equal(@retry_count+1, count)
        end

        should "only retry  'tries' times if the host is unreachable" do
          count = 0
          original_error = ::Manticore::Timeout.new
          e = ::Elasticsearch::Transport::Transport::HostUnreachableError.new(original_error, "http://localhost:9200")
          assert_raises e.class do
            @transport.with_request_retries do
              count += 1
              raise e
            end
          end

          # Add one for the orig request
          assert_equal(@retry_count+1, count)
        end

        should "reload connections if host is unreachable and all hosts are dead" do
          pool = mock()
          pool.expects(:alive_urls_count).returns(0).at_least_once
          @transport.expects(:pool).returns(pool).at_least_once
          @transport.expects(:reload_connections!).times(@retry_count)

          count = 0
          original_error = ::Manticore::Timeout.new
          e = ::Elasticsearch::Transport::Transport::HostUnreachableError.new(original_error, "http://localhost:9200")
          assert_raises e.class do
            @transport.with_request_retries do
              count += 1
              raise e
            end
          end
        end
      end
    end
  end
end
