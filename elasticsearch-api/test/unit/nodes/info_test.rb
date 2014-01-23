require 'test_helper'

module Elasticsearch
  module Test
    class NodesInfoTest < ::Test::Unit::TestCase

      context "Nodes: Info" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_nodes', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.nodes.info
        end

        should "send :node_id correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/foo', url
            true
          end.returns(FakeResponse.new)

          subject.nodes.info :node_id => 'foo'
        end

        should "send multiple :node_id-s correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/A,B,C', url
            true
          end.returns(FakeResponse.new).twice

          subject.nodes.info :node_id => 'A,B,C'
          subject.nodes.info :node_id => ['A', 'B', 'C']
        end

      end

    end
  end
end
