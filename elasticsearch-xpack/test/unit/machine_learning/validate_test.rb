require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlValidateTest < Minitest::Test

      context "XPack MachineLearning: Validate" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/anomaly_detectors/_validate", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.validate :body => {}
        end

      end

    end
  end
end
