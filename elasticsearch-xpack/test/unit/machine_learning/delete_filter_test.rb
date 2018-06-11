require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlDeleteFilterTest < Minitest::Test

      context "XPack MachineLearning: Delete filter" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal "_xpack/ml/filters/foo", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.delete_filter :filter_id => 'foo'
        end

      end

    end
  end
end
