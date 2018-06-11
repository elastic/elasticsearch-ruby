require 'test_helper'

module Elasticsearch
  module Test
    class XPackMigrationUpgradeTest < Minitest::Test

      context "XPack Migration: Upgrade" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_xpack/migration/upgrade/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.migration.upgrade :index => 'foo'
        end

      end

    end
  end
end
