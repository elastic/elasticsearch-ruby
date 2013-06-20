require 'test_helper'

module Elasticsearch
  module Test
    class IndicesGetWarmerTest < ::Test::Unit::TestCase

      context "Indices: Get warmer" do
        subject { FakeClient.new(nil) }

        should "require the :index argument" do
          assert_raise ArgumentError do
            subject.indices.get_warmer :name => 'foo'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_all/_warmer', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.get_warmer :index => '_all'
        end

        should "return single warmer" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_warmer/bar', url
            true
          end.returns(FakeResponse.new)

          subject.indices.get_warmer :index => 'foo', :name => 'bar'
        end

      end

    end
  end
end
