require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityDeleteRoleMappingTest < Minitest::Test

      context "XPack Security: Delete role mapping" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_xpack/security/role_mapping/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.delete_role_mapping :name => 'foo'
        end

      end

    end
  end
end
