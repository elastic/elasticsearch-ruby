require 'test_helper'

module Elasticsearch
  module Test
    class XPackMonitoringBulkTest < Minitest::Test

      context "XPack Monitoring: Bulk" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_xpack/monitoring/_bulk', url
            assert_equal Hash.new, params
            assert_equal "", body
            true
          end.returns(FakeResponse.new)

          subject.xpack.monitoring.bulk body: []
        end

      end

    end
  end
end
