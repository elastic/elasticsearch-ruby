require 'test_helper'

module Elasticsearch
  module Test
    class GetScriptTest < UnitTest

      context "Get script" do
        subject { FakeClient.new }

        should "perform correct request with specified lang" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_scripts/groovy/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.get_script :lang => "groovy", :id => 'foo'
        end

        should "perform correct request w/o lang" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_scripts/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.get_script :id => 'foo'
        end

      end

    end
  end
end
