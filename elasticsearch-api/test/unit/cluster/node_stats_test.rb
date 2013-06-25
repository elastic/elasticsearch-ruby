require 'test_helper'

module Elasticsearch
  module Test
    class ClusterNodeStatsTest < ::Test::Unit::TestCase

      context "Cluster: Node stats" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_nodes/stats', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_stats
        end

        should "send :node_id correctly" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/foo/stats', url
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_stats :node_id => 'foo'
        end

        should "get specific metric families" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/stats', url
            assert_equal( {:http => true, :fs => true}, params )
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_stats :http => true, :fs => true
        end

        should "get specific metric for the indices family" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/stats/indices/filter_cache', url
            true
          end.returns(FakeResponse.new)

          subject.cluster.node_stats :indices => true, :metric => 'filter_cache'
        end

        should "get fielddata statistics for the indices family" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_nodes/stats/indices/fielddata', url
            assert_equal( {:fields => 'foo,bar'}, params )
            true
          end.returns(FakeResponse.new).twice

          subject.cluster.node_stats :indices => true, :metric => 'fielddata', :fields => 'foo,bar'
          subject.cluster.node_stats :indices => true, :metric => 'fielddata', :fields => ['foo','bar']
        end

      end

    end
  end
end
