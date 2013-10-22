require 'test_helper'

module Elasticsearch
  module Test
    class BulkTest < ::Test::Unit::TestCase

      context "Bulk" do
        subject { FakeClient.new }

        should "post correct payload to the endpoint" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_bulk', url
            assert_equal Hash.new, params

            if RUBY_1_8
              lines = body.split("\n")

              assert_equal 5, lines.size
              assert_match /\{"index"\:\{/, lines[0]
              assert_match /\{"title"\:"Test"/, lines[1]
              assert_match /\{"update"\:\{/, lines[2]
              assert_match /\{"doc"\:\{"title"/, lines[3]
            else
              assert_equal <<-PAYLOAD.gsub(/^\s+/, ''), body
                {"index":{"_index":"myindexA","_type":"mytype","_id":"1"}}
                {"title":"Test"}
                {"update":{"_index":"myindexB","_type":"mytype","_id":"2"}}
                {"doc":{"title":"Update"}}
                {"delete":{"_index":"myindexC","_type":"mytypeC","_id":"3"}}
              PAYLOAD
            end
            true
          end.returns(FakeResponse.new)

          subject.bulk :body => [
            { :index =>  { :_index => 'myindexA', :_type => 'mytype', :_id => '1', :data => { :title => 'Test' } } },
            { :update => { :_index => 'myindexB', :_type => 'mytype', :_id => '2', :data => { :doc => { :title => 'Update' } } } },
            { :delete => { :_index => 'myindexC', :_type => 'mytypeC', :_id => '3' } }
          ]
        end

        should "post payload to the correct endpoint" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal 'myindex/_bulk', url
            true
          end.returns(FakeResponse.new)

          subject.bulk :index => 'myindex', :body => []
        end

        should "post a string payload" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal "foo\nbar", body
            true
          end.returns(FakeResponse.new)

          subject.bulk :body => "foo\nbar"
        end

        should "post an array of strings payload" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal "foo\nbar\n", body
            true
          end.returns(FakeResponse.new)

          subject.bulk :body => ["foo", "bar"]
        end

        should "encode URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal '_bulk', url
            assert_equal({:refresh => true}, params)
            true
          end.returns(FakeResponse.new)

          subject.bulk :refresh => true, :body => []
        end

        should "URL-escape the parts" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo%5Ebar/_bulk', url
            true
          end.returns(FakeResponse.new)

          subject.bulk :index => 'foo^bar', :body => []
        end

      end

    end
  end
end
