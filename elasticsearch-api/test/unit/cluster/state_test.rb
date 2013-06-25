require 'test_helper'

module Elasticsearch
  module Test
    class ClusterStateTest < ::Test::Unit::TestCase

      context "Cluster: State" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_cluster/state', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.cluster.state
        end

        should "send the API parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_cluster/state', url
            assert_equal({:filter_blocks => true}, params)
            true
          end.returns(FakeResponse.new)

          subject.cluster.state :filter_blocks => true
        end

      end

    end
  end
end
