require 'test_helper'

module Elasticsearch
  module Test
    class XPackLicenseGetTest < Minitest::Test

      context "License: Get" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/license', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.license.get
        end

      end

    end
  end
end
