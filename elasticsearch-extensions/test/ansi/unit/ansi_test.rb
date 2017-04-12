require 'test_helper'
require 'elasticsearch/extensions/ansi'

class Elasticsearch::Extensions::AnsiTest < Elasticsearch::Test::UnitTestCase
  context "The ANSI extension" do
    setup do
      @client = Elasticsearch::Client.new
      @client.stubs(:perform_request).returns \
        Elasticsearch::Transport::Transport::Response.new(200, { "ok" => true, "status" => 200, "name" => "Hit-Maker",
            "version" => { "number"     => "0.90.7",
                           "build_hash" => "abc123",
                           "build_timestamp"=>"2013-11-13T12:06:54Z", "build_snapshot"=>false, "lucene_version"=>"4.5.1" },
            "tagline"=>"You Know, for Search" })
    end

    should "wrap the response" do
      response = @client.info

      assert_instance_of Elasticsearch::Extensions::ANSI::ResponseBody, response
      assert_instance_of Hash, response.to_hash
    end

    should "extend the response object with `to_ansi`" do
      response = @client.info

      assert_respond_to response, :to_ansi
      assert_instance_of String, response.to_ansi
    end

    should "call the 'awesome_inspect' method when available and no handler found" do
      @client.stubs(:perform_request).returns \
        Elasticsearch::Transport::Transport::Response.new(200, {"index-1"=>{"aliases"=>{}}})
      response = @client.indices.get_aliases

      response.instance_eval do
        def awesome_inspect; "---PRETTY---"; end
      end
      assert_equal '---PRETTY---', response.to_ansi
    end

    should "call `to_s` method when no pretty printer or handler found" do
      @client.stubs(:perform_request).returns \
        Elasticsearch::Transport::Transport::Response.new(200, {"index-1"=>{"aliases"=>{}}})
      response = @client.indices.get_aliases

      assert_equal '{"index-1"=>{"aliases"=>{}}}', response.to_ansi
    end
  end
end
