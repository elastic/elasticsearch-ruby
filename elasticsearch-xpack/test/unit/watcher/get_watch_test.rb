require 'test_helper'

module Elasticsearch
  module Test
    class XPackWatcherGetWatchTest < Minitest::Test

      context "XPack Watcher: Get watch" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/watcher/watch/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.watcher.get_watch id: 'foo'
        end

      end

    end
  end
end
