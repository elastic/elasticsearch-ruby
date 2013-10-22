require 'test_helper'

module Elasticsearch
  module Test
    class PercolateTest < ::Test::Unit::TestCase

      context "Percolate" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raise ArgumentError do
            subject.percolate :type => 'bar', :body => {}
          end
        end

        should "require the :body argument" do
          assert_raise ArgumentError do
            subject.percolate :index => 'bar'
          end
        end

        should "have default document type" do
          assert_nothing_raised do
            subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/document/_percolate', url
            true
          end.returns(FakeResponse.new)

            subject.percolate :index => 'foo', :body => {}
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal 'foo/bar/_percolate', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:doc][:foo]
            true
          end.returns(FakeResponse.new)

          subject.percolate :index => 'foo', :type => 'bar', :body => { :doc => { :foo => 'bar' } }
        end

        should "URL-escape the parts" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo%5Ebar/bar%2Fbam/_percolate', url
            true
          end.returns(FakeResponse.new)

          subject.percolate :index => 'foo^bar', :type => 'bar/bam', :body => { :doc => { :foo => 'bar' } }
        end

      end

    end
  end
end
