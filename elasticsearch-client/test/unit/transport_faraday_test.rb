require 'test_helper'

class Elasticsearch::Client::Transport::HTTP::FaradayTest < Test::Unit::TestCase
  include Elasticsearch::Client::Transport::HTTP

  context "Faraday transport" do
    setup do
      @transport = Faraday.new :hosts => [ { :host => 'foobar', :port => 1234 } ]
    end

    should "implement __build_connections" do
      assert_equal 1, @transport.hosts.size
      assert_equal 1, @transport.connections.size

      assert_instance_of ::Faraday::Connection, @transport.connections.first.connection
      assert_equal 'http://foobar:1234/', @transport.connections.first.connection.url_prefix.to_s
    end

    should "perform the request" do
      @transport.connections.first.connection.expects(:run_request).returns(stub_everything)
      @transport.perform_request 'GET', '/'
    end

    should "properly prepare the request" do
      @transport.connections.first.connection.expects(:run_request).with do |method, url, body, headers|
        :post == method && '{"foo":"bar"}' == body
      end.returns(stub_everything)
      @transport.perform_request 'POST', '/', {}, {:foo => 'bar'}
    end

    should "pass the selector_class options to collection" do
      @transport = Faraday.new :hosts => [ { :host => 'foobar', :port => 1234 } ],
                               :options => { :selector_class => Elasticsearch::Client::Transport::Connections::Selector::Random }
      assert_instance_of Elasticsearch::Client::Transport::Connections::Selector::Random,
                         @transport.connections.selector
    end

    should "pass the selector option to collection" do
      @transport = Faraday.new :hosts => [ { :host => 'foobar', :port => 1234 } ],
                               :options => { :selector => Elasticsearch::Client::Transport::Connections::Selector::Random.new }
      assert_instance_of Elasticsearch::Client::Transport::Connections::Selector::Random,
                         @transport.connections.selector
    end

  end

end
