require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlPostDataTest < Minitest::Test

      context "XPack MachineLearning: Post data" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/anomaly_detectors/foo/_data", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.post_data :job_id => 'foo', :body => {}
        end

      end

    end
  end
end
