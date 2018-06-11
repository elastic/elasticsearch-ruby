require 'test_helper'

module Elasticsearch
  module Test
    class XPackWatcherStartTest < Minitest::Test

      context "XPack Watcher: Start" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_xpack/watcher/_start', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.watcher.start
        end

      end

    end
  end
end
