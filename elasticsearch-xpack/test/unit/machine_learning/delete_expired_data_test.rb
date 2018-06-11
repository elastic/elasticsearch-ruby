require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlDeleteExpiredDataTest < Minitest::Test

      context "XPack MachineLearning: Delete expired data" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal "_xpack/ml/_delete_expired_data", url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.delete_expired_data
        end

      end

    end
  end
end
