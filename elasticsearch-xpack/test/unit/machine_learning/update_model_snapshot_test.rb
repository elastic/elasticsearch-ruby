require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlUpdateModelSnapshotTest < Minitest::Test

      context "XPack MachineLearning: Update model snapshot" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/anomaly_detectors/foo/model_snapshots/bar/_update", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.update_model_snapshot :job_id => 'foo', :snapshot_id => 'bar', :body => {}
        end

      end

    end
  end
end
