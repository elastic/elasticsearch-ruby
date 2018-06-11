require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlGetDatafeedsTest < Minitest::Test

      context "XPack MachineLearning: Get datafeeds" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "_xpack/ml/datafeeds/foo", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.get_datafeeds :datafeed_id => 'foo'
        end

      end

    end
  end
end
