require 'test_helper'

module Elasticsearch
  module Test
    class IndicesSplitTest < ::Test::Unit::TestCase

      context "Indices: Split" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal 'foo/_split/bar', url
            assert_equal Hash.new, params
            assert_nil body
            true
          end.returns(FakeResponse.new)

          subject.indices.split :index => 'foo', :target => 'bar'
        end
      end
    end
  end
end
