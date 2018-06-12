require 'test_helper'

module Elasticsearch
  module Test
    class XPackWatcherAckWatchTest < Minitest::Test

      context "XPack Watcher: Ack watch" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/watcher/watch/foo/_ack', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.watcher.ack_watch watch_id: 'foo'
        end

      end

    end
  end
end
