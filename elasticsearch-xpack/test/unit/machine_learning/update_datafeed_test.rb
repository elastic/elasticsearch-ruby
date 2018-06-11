require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlUpdateDatafeedTest < Minitest::Test

      context "XPack MachineLearning: Update datafeed" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/datafeeds/foo/_update", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.update_datafeed :datafeed_id => 'foo', :body => {}
        end

      end

    end
  end
end
