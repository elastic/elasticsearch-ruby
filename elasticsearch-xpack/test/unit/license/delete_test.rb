require 'test_helper'

module Elasticsearch
  module Test
    class XPackLicenseDeleteTest < Minitest::Test

      context "License: Delete" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_xpack/license', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.license.delete
        end

      end

    end
  end
end
