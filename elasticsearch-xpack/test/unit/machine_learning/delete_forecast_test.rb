# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlDeleteForecastTest < Minitest::Test

      context "XPack MachineLearning: Delete forecast" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal "_ml/anomaly_detectors/foo/_forecast", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.delete_forecast :job_id => 'foo'
        end

      end

    end
  end
end
