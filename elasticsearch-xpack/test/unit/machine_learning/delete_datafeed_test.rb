require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlDeleteDatafeedTest < Minitest::Test

      context "XPack MachineLearning: Delete datafeed" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal "_xpack/ml/datafeeds/foo", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.delete_datafeed :datafeed_id => 'foo'
        end

      end

    end
  end
end
