# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'test_helper'

module Elasticsearch
  module Test
    class FindFileStructuretest < Minitest::Test

      context "XPack MachineLearning: Find file structure" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_xpack/ml/find_file_structure", url
            assert_equal Hash.new, params
            assert_equal "", body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ml.find_file_structure body: []
        end

      end

    end
  end
end
