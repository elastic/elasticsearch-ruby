require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlGetModelSnapshotsTest < Minitest::Test

      context "XPack MachineLearning: Get model snapshots" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "_xpack/ml/anomaly_detectors/foo/model_snapshots/bar", url
            assert_equal Hash.new, params
            assert_equal nil, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.get_model_snapshots :job_id => 'foo', :snapshot_id => 'bar'
        end

      end

    end
  end
end
