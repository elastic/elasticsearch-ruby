require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityChangePasswordTest < Minitest::Test

      context "XPack Security: Change password" do
        subject { FakeClient.new }

        should "perform correct request for a specific user" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/security/user/foo/_password', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:password]
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.change_password username: 'foo', body: { password: 'bar' }
        end

        should "perform correct request for current user" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/security/user/_password', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:password]
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.change_password body: { password: 'bar' }
        end

      end

    end
  end
end
