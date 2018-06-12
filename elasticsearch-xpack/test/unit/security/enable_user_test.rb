require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityEnableUserTest < Minitest::Test

      context "XPack Security: Enable user" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "_xpack/security/user/foo/_enable", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.enable_user :username => 'foo'
        end

      end

    end
  end
end
