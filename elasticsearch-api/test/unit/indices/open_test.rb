require 'test_helper'

module Elasticsearch
  module Test
    class IndicesOpenTest < ::Test::Unit::TestCase

      context "Indices: Open" do
        subject { FakeClient.new(nil) }

        should "require the :index argument" do
          assert_raise ArgumentError do
            subject.indices.open
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal 'foo/_open', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.open :index => 'foo'
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_open', url
            assert_equal '1s', params[:timeout]
            true
          end.returns(FakeResponse.new)

          subject.indices.open :index => 'foo', :timeout => '1s'
        end

      end

    end
  end
end
