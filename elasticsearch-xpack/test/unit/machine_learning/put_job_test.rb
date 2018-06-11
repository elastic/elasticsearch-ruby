require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlPutJobTest < Minitest::Test

      context "XPack MachineLearning: Put job" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "_xpack/ml/anomaly_detectors/foo", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.put_job :job_id => 'foo', :body => {}
        end

      end

    end
  end
end
