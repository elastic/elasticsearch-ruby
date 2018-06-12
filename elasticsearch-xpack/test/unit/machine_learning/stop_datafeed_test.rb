require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlStopDatafeedTest < Minitest::Test

      context "XPack MachineLearning: Stop datafeed" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/datafeeds/foo/_stop", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.stop_datafeed :datafeed_id => 'foo'
        end

      end

    end
  end
end
