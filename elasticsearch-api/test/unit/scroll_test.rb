require 'test_helper'

module Elasticsearch
  module Test
    class ScrollTest < ::Test::Unit::TestCase

      context "Scroll" do
        subject { FakeClient.new }

        context "consuming scroll search" do

          should "perform correct request" do
            subject.expects(:perform_request).with do |method, url, params, body|
              assert_equal 'GET', method
              assert_equal '_search/scroll', url
              assert_equal 'cXVlcn...', params[:scroll_id]
              assert_nil   body
              true
            end.returns(FakeResponse.new)

            subject.scroll :scroll_id => 'cXVlcn...'
          end
        end

        context "clearing scroll" do

          should "perform correct request" do
            subject.expects(:perform_request).with do |method, url, params, body|
              assert_equal 'DELETE', method
              assert_equal '_search/scroll', url
              assert_equal 'cXVlcn...', params[:scroll_id]
              assert_nil   body
              true
            end.returns(FakeResponse.new)

            subject.scroll :scroll_id => 'cXVlcn...', :clear => true
          end
        end

      end

    end
  end
end
