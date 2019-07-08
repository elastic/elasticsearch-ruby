require 'test_helper'

module Elasticsearch
  module Test
    class FindFileStructuretest < Minitest::Test

      context "XPack MachineLearning: Find file structure" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal "_ml/find_file_structure", url
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
