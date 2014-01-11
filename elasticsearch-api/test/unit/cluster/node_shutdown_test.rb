require 'test_helper'

module Elasticsearch
  module Test
    class ClusterNodeShutdownTest < ::Test::Unit::TestCase

      context "Cluster: Node shutdown" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_nodes/_shutdown', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_shutdown
        end

        should "send :node_id correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/foo/_shutdown', url
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_shutdown :node_id => 'foo'
        end

        should "send multiple :node_id-s correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/A,B,C/_shutdown', url
            true
          end.returns(FakeResponse.new).twice

          subject.cluster.node_shutdown :node_id => 'A,B,C'
          subject.cluster.node_shutdown :node_id => ['A', 'B', 'C']
        end

      end

    end
  end
end
