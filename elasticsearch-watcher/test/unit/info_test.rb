require 'test_helper'

module Elasticsearch
  module Test
    class WatcherInfoTest < ::Test::Unit::TestCase

      context "Watcher: Info" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '/_watcher/', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.watcher.info
        end

      end

    end
  end
end
