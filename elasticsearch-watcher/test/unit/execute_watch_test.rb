require 'test_helper'

module Elasticsearch
  module Test
    class WatcherExecuteWatchTest < ::Test::Unit::TestCase

      context "Watcher: Execute watch" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "_watcher/watch/foo/_execute", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.watcher.execute_watch id: 'foo', body: {}
        end

      end

    end
  end
end
