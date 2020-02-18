require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityDeletePrivilegesTest < Minitest::Test

      context "XPack Security: Delete privileges" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_security/privilege/foo/bar', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.delete_privileges :application => 'foo', name: 'bar'
        end

      end

    end
  end
end
