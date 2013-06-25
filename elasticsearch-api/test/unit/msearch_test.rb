require 'test_helper'

module Elasticsearch
  module Test
    class MsearchTest < ::Test::Unit::TestCase

      context "Msearch" do
        subject { FakeClient.new }

        should "require the :body argument" do
          assert_raise ArgumentError do
            subject.msearch
          end
        end

        should "post correct payload to the endpoint" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_msearch', url
            assert_equal Hash.new, params
            assert_equal <<-PAYLOAD.gsub(/^\s+/, ''), body
            {"index":"foo"}
            {"query":{"match_all":{}}}
            {"index":"bar"}
            {"query":{"match":{"foo":"bar"}}}
            {"search_type":"count"}
            {"facets":{"tags":{}}}
            PAYLOAD
            true
          end.returns(FakeResponse.new)

          subject.msearch :body => [
            { :index => 'foo', :search => { :query => { :match_all => {}  } } },
            { :index => 'bar', :search => { :query => { :match => { :foo => 'bar' } } } },
            { :search_type => 'count', :search => { :facets => { :tags => {} } } }
          ]
        end

        should "post a string payload intact" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal "foo\nbar", body
            true
          end.returns(FakeResponse.new)

          subject.msearch :body => "foo\nbar"
        end

        should "perform request against an index" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_msearch', url
            true
          end.returns(FakeResponse.new)

          subject.msearch :index => 'foo', :body => []
        end

        should "perform request against an index and type" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/bar/_msearch', url
            true
          end.returns(FakeResponse.new)

          subject.msearch :index => 'foo', :type => 'bar', :body => []
        end

        should "perform request against multiple indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/_msearch', url
            true
          end.returns(FakeResponse.new)

          subject.msearch :index => ['foo', 'bar'], :body => []
        end

        should "perform request against multiple indices and types" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/lam,bam/_msearch', url
            true
          end.returns(FakeResponse.new)

          subject.msearch :index => ['foo', 'bar'], :type => ['lam', 'bam'], :body => []
        end

        should "encode URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_msearch', url
            assert_equal 'scroll', params[:search_type]
            true
          end.returns(FakeResponse.new)

          subject.msearch :body => [], :search_type => 'scroll'
        end

      end

    end
  end
end
