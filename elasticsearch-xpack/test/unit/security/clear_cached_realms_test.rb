require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityClearCachedRealmsTest < Minitest::Test

      context "XPack Security: Clear cached realms" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/security/realm/foo,bar/_clear_cache", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.clear_cached_realms :realms => ['foo', 'bar']
        end

      end

    end
  end
end
