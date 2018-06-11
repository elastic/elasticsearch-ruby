require 'test_helper'

module Elasticsearch
  module Test
    class GraphExploreTest < Minitest::Test

      context "Graph: Explore" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/_graph/_explore', url
            assert_equal Hash.new, params
            assert_equal nil, body
            true
          end.returns(FakeResponse.new)

          subject.xpack.graph.explore
        end

      end

    end
  end
end
