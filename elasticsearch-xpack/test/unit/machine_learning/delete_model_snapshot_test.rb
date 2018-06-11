require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlDeleteModelSnapshotTest < Minitest::Test

      context "XPack MachineLearning: Delete model snapshot" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal "_xpack/ml/anomaly_detectors/foo/model_snapshots/bar", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.delete_model_snapshot :job_id => 'foo', :snapshot_id => 'bar'
        end

      end

    end
  end
end
