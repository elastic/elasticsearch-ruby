require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityDeleteRoleTest < Minitest::Test

      context "XPack Security: Delete role" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_xpack/security/role/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.delete_role :name => 'foo'
        end

      end

    end
  end
end
