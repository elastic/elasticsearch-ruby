require 'test_helper'

module Elasticsearch
  module Test
    class WatcherAckWatchTest < ::Test::Unit::TestCase

      context "Watcher: Ack watch" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/watcher/watch/foo/_ack', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.watcher.ack_watch id: 'foo'
        end

      end

    end
  end
end
