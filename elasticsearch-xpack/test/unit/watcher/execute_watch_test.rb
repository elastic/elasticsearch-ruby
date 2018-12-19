require 'test_helper'

module Elasticsearch
  module Test
    class XPackWatcherExecuteWatchTest < Minitest::Test

      context "XPack Watcher: Execute watch" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/watcher/watch/foo/_execute', url
            assert_equal Hash.new, params
            assert_equal nil, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.watcher.execute_watch id: 'foo'
        end

        should "perform correct request with no id specified" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/watcher/watch/_execute', url
            assert_equal Hash.new, params
            assert_equal nil, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.watcher.execute_watch
        end

      end

    end
  end
end
