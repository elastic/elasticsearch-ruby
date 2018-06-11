require 'test_helper'

module Elasticsearch
  module Test
    class XPackUsageTest < Minitest::Test

      context "XPack: Usage" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/usage', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.usage
        end

      end

    end
  end
end
