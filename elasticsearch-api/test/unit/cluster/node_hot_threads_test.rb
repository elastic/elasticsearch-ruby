require 'test_helper'

module Elasticsearch
  module Test
    class ClusterNodeHotThreadsTest < ::Test::Unit::TestCase

      context "Cluster: Node hot threads" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_nodes/hot_threads', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_hot_threads
        end

        should "send :node_id correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/foo/hot_threads', url
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_hot_threads :node_id => 'foo'
        end

        should "URL-escape the parts" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/foo%5Ebar/hot_threads', url
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_hot_threads :node_id => 'foo^bar'
        end

      end

    end
  end
end
