require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityAuthenticateTest < Minitest::Test

      context "XPack Security: Authenticate" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/_authenticate', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.authenticate
        end

      end

    end
  end
end
