require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityClearCachedRolesTest < Minitest::Test

      context "XPack Security: Clear cached roles" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/security/role/foo/_clear_cache', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.clear_cached_roles :name => 'foo'
        end

      end

    end
  end
end
