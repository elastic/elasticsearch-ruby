require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlPreviewDatafeedTest < Minitest::Test

      context "XPack MachineLearning: Preview datafeed" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "_xpack/ml/datafeeds/foo/_preview", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.preview_datafeed :datafeed_id => 'foo'
        end

      end

    end
  end
end
