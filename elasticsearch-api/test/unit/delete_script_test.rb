require 'test_helper'

module Elasticsearch
  module Test
    class DeleteScriptTest < UnitTest

      context "Delete script" do
        subject { FakeClient.new }

        should "perform correct request with specified lang" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_scripts/groovy/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.delete_script :lang => "groovy", :id => "foo"
        end

        should "perform correct request w/o lang" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal '_scripts/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.delete_script :id => "foo"
        end

      end

    end
  end
end
