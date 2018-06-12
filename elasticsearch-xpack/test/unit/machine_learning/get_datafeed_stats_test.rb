require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlGetDatafeedStatsTest < Minitest::Test

      context "XPack MachineLearning: Get datafeed stats" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "_xpack/ml/datafeeds/_stats", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.get_datafeed_stats
        end

      end

    end
  end
end
