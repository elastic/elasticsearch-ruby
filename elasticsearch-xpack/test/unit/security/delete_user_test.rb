require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityDeleteUserTest < Minitest::Test

      context "XPack Security: Delete user" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_xpack/security/user/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.delete_user :username => 'foo'
        end

      end

    end
  end
end
