require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlGetRecordsTest < Minitest::Test

      context "XPack MachineLearning: Get records" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "_xpack/ml/anomaly_detectors/foo/results/records", url
            assert_equal Hash.new, params
            assert_equal nil, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.get_records :job_id => 'foo'
        end

      end

    end
  end
end
