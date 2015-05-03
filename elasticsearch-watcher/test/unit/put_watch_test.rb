require 'test_helper'

module Elasticsearch
  module Test
    class WatcherPutWatchTest < ::Test::Unit::TestCase

      context "Watcher: Put watch" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "_watcher/watch/foo", url
            assert_equal Hash.new, params
            assert_equal({foo: 'bar'}, body)
            true
          end.returns(FakeResponse.new)

          subject.watcher.put_watch id: 'foo', body: { foo: 'bar' }
        end

      end

    end
  end
end
