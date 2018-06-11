require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlGetJobStatsTest < Minitest::Test

      context "XPack MachineLearning: Get job stats" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "_xpack/ml/anomaly_detectors/foo/_stats", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.get_job_stats :job_id => 'foo'
        end

      end

    end
  end
end
