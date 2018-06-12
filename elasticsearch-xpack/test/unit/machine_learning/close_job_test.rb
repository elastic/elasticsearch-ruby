require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlCloseJobTest < Minitest::Test

      context "XPack MachineLearning: Close job" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/anomaly_detectors/foo/_close", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.close_job :job_id => 'foo'
        end

      end

    end
  end
end
