require 'test_helper'

class Elasticsearch::Client::Transport::Connections::ConnectionTest < Test::Unit::TestCase
  include Elasticsearch::Client::Transport::Connections

  context "Connection" do

    should "be initialized with :host, :connection, and :options" do
      c = Connection.new :host => 'x', :connection => 'y', :options => 'z'
      assert_equal 'x', c.host
      assert_equal 'y', c.connection
      assert_equal 'z', c.options
    end

    should "return full path" do
      c = Connection.new
      assert_equal '_search', c.full_path('_search')
      assert_equal '_search', c.full_path('_search', {})
      assert_equal '_search?foo=bar', c.full_path('_search', {:foo => 'bar'})
      assert_equal '_search?foo=bar+bam', c.full_path('_search', {:foo => 'bar bam'})
    end

    should "return full url" do
      c = Connection.new :host => { :protocol => 'http', :host => 'localhost', :port => '9200' }
      assert_equal 'http://localhost:9200/_search?foo=bar', c.full_url('_search', {:foo => 'bar'})
    end

    should "have a string representation" do
      c = Connection.new :host => 'x'
      assert_match /host: x/, c.to_s
    end

  end

end
