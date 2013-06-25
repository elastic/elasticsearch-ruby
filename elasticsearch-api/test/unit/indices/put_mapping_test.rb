require 'test_helper'

module Elasticsearch
  module Test
    class IndicesPutMappingTest < ::Test::Unit::TestCase

      context "Indices: Put mapping" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raise ArgumentError do
            subject.indices.put_mapping :type => 'bar'
          end
        end

        should "require the :type argument" do
          assert_raise ArgumentError do
            subject.indices.put_mapping :index => 'foo'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal 'foo/bar/_mapping', url
            assert_equal Hash.new, params
            assert_equal({ :foo => {} }, body)
            true
          end.returns(FakeResponse.new)

          subject.indices.put_mapping :index => 'foo', :type => 'bar', :body => { :foo => {} }
        end

        should "perform request against multiple indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/bam/_mapping', url
            true
          end.returns(FakeResponse.new)

          subject.indices.put_mapping :index => ['foo','bar'], :type => 'bam', :body => {}
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/bar/_mapping', url
            assert_equal true, params[:ignore_conflicts]
            true
          end.returns(FakeResponse.new)

          subject.indices.put_mapping :index => 'foo', :type => 'bar', :body => {}, :ignore_conflicts => true
        end

      end

    end
  end
end
