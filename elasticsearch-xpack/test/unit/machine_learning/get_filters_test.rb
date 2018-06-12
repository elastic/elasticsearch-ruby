require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlGetFiltersTest < Minitest::Test

      context "XPack MachineLearning: Get filters" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "_xpack/ml/filters/foo", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.get_filters :filter_id => 'foo'
        end

      end

    end
  end
end
