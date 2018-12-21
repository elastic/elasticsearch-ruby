require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityPutPrivilegesTest < Minitest::Test

      context "XPack Security: Put role" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_xpack/security/privilege', url
            assert_equal Hash.new, params
            assert_equal({ "app-allow": { read: { actions: [ "data:read/*" ] } } }, body)
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.put_privileges(body: { "app-allow": { read: { actions: [ "data:read/*" ] } } })
        end

      end

    end
  end
end
