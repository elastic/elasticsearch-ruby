require 'test_helper'

module Elasticsearch
  module Test
    class WatcherStartTest < ::Test::Unit::TestCase

      context "Watcher: Start" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "/_watcher/_start", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.watcher.start
        end

      end

    end
  end
end
