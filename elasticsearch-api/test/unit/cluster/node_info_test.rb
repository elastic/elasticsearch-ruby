require 'test_helper'

module Elasticsearch
  module Test
    class ClusterNodeInfoTest < ::Test::Unit::TestCase

      context "Cluster: Node info" do
        subject { FakeClient.new(nil) }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_cluster/nodes', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_info
        end

        should "send :node_id correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_cluster/nodes/foo', url
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_info :node_id => 'foo'
        end

        should "send multiple :node_id-s correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_cluster/nodes/A,B,C', url
            true
          end.returns(FakeResponse.new).twice

          subject.cluster.node_info :node_id => 'A,B,C'
          subject.cluster.node_info :node_id => ['A', 'B', 'C']
        end

      end

    end
  end
end
