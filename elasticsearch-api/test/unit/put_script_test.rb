require 'test_helper'

module Elasticsearch
  module Test
    class PutScriptTest < ::Test::Unit::TestCase

      context "Put script" do
        subject { FakeClient.new }

        should "perform correct request with specified lang" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_scripts/groovy/foo', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:script]
            true
          end.returns(FakeResponse.new)

          subject.put_script :lang => 'groovy', :id => 'foo', :body => { :script => 'bar' }
        end

        should "perform correct request w/o lang" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_scripts/foo', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:script]
            true
          end.returns(FakeResponse.new)

          subject.put_script :id => 'foo', :body => { :script => 'bar' }
        end

      end

    end
  end
end
