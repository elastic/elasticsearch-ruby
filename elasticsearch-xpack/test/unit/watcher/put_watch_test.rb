require 'test_helper'

module Elasticsearch
  module Test
    class XPackWatcherPutWatchTest < Minitest::Test

      context "XPack Watcher: Put watch" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/watcher/watch/foo', url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.watcher.put_watch id: 'foo', body: {}
        end

      end

    end
  end
end
