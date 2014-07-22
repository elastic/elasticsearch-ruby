require 'test_helper'

module Elasticsearch
  module Test
    class GetTemplateTest < ::Test::Unit::TestCase

      context "Get template" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_search/template/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.get_template :id => "foo"
        end

      end

    end
  end
end
