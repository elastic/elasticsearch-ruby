require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlStartDatafeedTest < Minitest::Test

      context "XPack MachineLearning: Start datafeed" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/datafeeds/foo/_start", url
            assert_equal Hash.new, params
            assert_equal nil, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.start_datafeed :datafeed_id => 'foo'
        end

      end

    end
  end
end
