require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityHasPrivilegesTest < Minitest::Test

      context "XPack Security: Has Privileges" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/user/_has_privileges', url
            assert_equal Hash.new, params
            assert_equal({ cluster: [], index: [], application: [] }, body)
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.has_privileges(body: { cluster: [], index: [], application: [] })
        end

        should "check privileges for a specific user" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/user/foo/_has_privileges', url
            assert_equal Hash.new, params
            assert_equal({ cluster: [], index: [], application: [] }, body)
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.has_privileges(user: 'foo', body: { cluster: [], index: [], application: [] })
        end

      end

    end
  end
end
