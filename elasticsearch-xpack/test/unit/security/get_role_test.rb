require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityGetRoleTest < Minitest::Test

      context "XPack Security: Get role" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/role', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.get_role
        end

        should "perform correct request for multiple roles" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/role/foo,bar', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.get_role name: ['foo', 'bar']
        end

        should "catch a NotFound exception with the ignore parameter" do
          subject.expects(:perform_request).raises(NotFound)

          assert_nothing_raised do
            subject.xpack.security.get_role name: 'foo', ignore: 404
          end
        end
      end

    end
  end
end
