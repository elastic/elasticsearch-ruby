require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityDisableUserTest < Minitest::Test

      context "XPack Security: Disable user" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "_xpack/security/user/foo/_disable", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.disable_user :username => 'foo'
        end

      end

    end
  end
end
