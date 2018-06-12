require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityPutRoleMappingTest < Minitest::Test

      context "XPack Security: Put role mapping" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "_xpack/security/role_mapping/foo", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.put_role_mapping :name => 'foo', :body => {}
        end

      end

    end
  end
end
