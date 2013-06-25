require 'test_helper'

module Elasticsearch
  module Test
    class IndicesGetAliasesTest < ::Test::Unit::TestCase

      context "Indices: Get aliases" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_aliases', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.get_aliases
        end

        should "perform request against an index" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_aliases', url
            true
          end.returns(FakeResponse.new)

          subject.indices.get_aliases :index => 'foo'
        end

      end

    end
  end
end
