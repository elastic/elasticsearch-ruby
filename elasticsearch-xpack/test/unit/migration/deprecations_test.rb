require 'test_helper'

module Elasticsearch
  module Test
    class XPackMigrationDeprecationsTest < Minitest::Test
      context "XPack Migration: Deprecations" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/migration/deprecations', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.migration.deprecations
        end

      end

    end
  end
end
