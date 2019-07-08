require 'test_helper'

module Elasticsearch
  module Test
    class XPackMlGetRollupIndexCapsTest < Minitest::Test

      context "XPack Rollup: Get index caps" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal "foo/_rollup/data", url
            assert_equal Hash.new, params
            assert_equal nil, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.rollup.get_rollup_index_caps :index => 'foo'
        end

      end

    end
  end
end
