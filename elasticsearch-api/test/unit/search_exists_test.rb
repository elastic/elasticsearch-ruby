require 'test_helper'

module Elasticsearch
  module Test
    class SearchExistsTest < ::Test::Unit::TestCase

      context "Search exists" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_search/exists', url
            assert_equal 'foo', params[:q]
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.search_exists :q => 'foo'
        end

        should "perform request against an index" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal 'books/_search/exists', url
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.search_exists :index => 'books'
        end

        should "perform request against an index and type" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal 'books/holly/_search/exists', url
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.search_exists :index => 'books', :type => 'holly'
        end

        should "perform request against default index if type given" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_all/holly/_search/exists', url
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.search_exists :type => 'holly'
        end
      end

    end
  end
end
