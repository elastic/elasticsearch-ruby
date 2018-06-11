require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlPutFilterTest < Minitest::Test

      context "XPack MachineLearning: Put filter" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal "_xpack/ml/filters/foo", url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.put_filter :filter_id => 'foo', :body => {}
        end

      end

    end
  end
end
