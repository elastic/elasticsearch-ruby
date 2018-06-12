require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlValidateDetectorTest < Minitest::Test

      context "XPack MachineLearning: Validate detector" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/anomaly_detectors/_validate/detector", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.validate_detector :body => {}
        end

      end

    end
  end
end
