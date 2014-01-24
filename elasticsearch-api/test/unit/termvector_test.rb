require 'test_helper'

module Elasticsearch
  module Test
    class TermvectorTest < ::Test::Unit::TestCase

      context "Termvector" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raise ArgumentError do
            subject.termvector :type => 'bar', :id => '1'
          end
        end

        should "require the :type argument" do
          assert_raise ArgumentError do
            subject.termvector :index => 'foo', :id => '1'
          end
        end

        should "require the :id argument" do
          assert_raise ArgumentError do
            subject.termvector :index => 'foo', :type => 'bar'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal 'foo/bar/123/_termvector', url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.termvector :index => 'foo', :type => 'bar', :id => '123', :body => {}
        end

      end

    end
  end
end
