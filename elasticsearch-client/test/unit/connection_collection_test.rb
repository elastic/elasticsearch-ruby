require 'test_helper'

class Elasticsearch::Client::Transport::Connections::CollectionTest < Test::Unit::TestCase
  include Elasticsearch::Client::Transport::Connections

  context "Connection collection" do

    should "have empty array as default connections array" do
      assert_equal [], Collection.new.connections
    end

    should "have default selector class" do
      assert_not_nil Collection.new.selector
    end

    should "initialize a custom selector class" do
      c = Collection.new :selector_class => Selector::Random
      assert_instance_of Selector::Random, c.selector
    end

    should "take a custom selector instance" do
      c = Collection.new :selector => Selector::Random.new
      assert_instance_of Selector::Random, c.selector
    end

    should "get connection from selector" do
      c = Collection.new
      c.selector.expects(:select).returns('OK')
      assert_equal 'OK', c.get_connection
    end

    should "return an array of hosts" do
      c = Collection.new :connections => [ stub(:host => 'foo'), stub(:host => 'bar') ]
      assert_equal ['foo', 'bar'], c.hosts
    end

    should "be enumerable" do
      c = Collection.new :connections => [ stub(:host => 'foo'), stub(:host => 'bar') ]

      assert_equal ['FOO', 'BAR'], c.map { |i| i.host.upcase }
      assert_equal 'foo',          c[0].host
      assert_equal 'bar',          c[1].host
      assert_equal  2,             c.size
    end

  end

end
