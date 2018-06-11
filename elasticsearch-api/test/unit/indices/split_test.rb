require 'test_helper'

module Elasticsearch
  module Test
    class IndicesSplitTest < ::Test::Unit::TestCase

      context "Indices: Split" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'FAKE', method
            assert_equal 'test', url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.indices.split :index => 'foo', :target => 'foo'
        end

      end

    end
  end
end
