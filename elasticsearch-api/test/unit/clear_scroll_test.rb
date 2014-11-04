require 'test_helper'

module Elasticsearch
  module Test
    class ClearScrollTest < ::Test::Unit::TestCase

      context "Clear scroll" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_search/scroll', url
            assert_equal Hash.new, params
            assert_equal 'abc123', body
            true
          end.returns(FakeResponse.new)

          subject.clear_scroll :scroll_id => 'abc123'
        end

        should "listify scroll IDs" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_search/scroll', url
            assert_equal Hash.new, params
            assert_equal 'abc123,def456', body
            true
          end.returns(FakeResponse.new)

          subject.clear_scroll :scroll_id => ['abc123', 'def456']
        end

      end

    end
  end
end
