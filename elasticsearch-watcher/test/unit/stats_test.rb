require 'test_helper'

module Elasticsearch
  module Test
    class WatcherStatsTest < ::Test::Unit::TestCase

      context "Watcher: Stats" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "/_watcher/stats", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.watcher.stats
        end

      end

    end
  end
end
