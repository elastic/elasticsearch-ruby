require 'test_helper'

module Elasticsearch
  module Test
    class WatcherRestartTest < ::Test::Unit::TestCase

      context "Watcher: Restart" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "/_watcher/_restart", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.watcher.restart
        end

      end

    end
  end
end
