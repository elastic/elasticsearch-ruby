require 'test_helper'

module Elasticsearch
  module Test
    class IndicesPutAliasTest < ::Test::Unit::TestCase

      context "Indices: Put alias" do
        subject { FakeClient.new(nil) }

        should "require the :index argument" do
          assert_raise ArgumentError do
            subject.indices.put_alias :name => 'bar'
          end
        end

        should "require the :name argument" do
          assert_raise ArgumentError do
            subject.indices.put_alias :index => 'foo'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal 'foo/_alias/bar', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.put_alias :index => 'foo', :name => 'bar'
        end

        should "send the alias settings in :body" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo', body[:filter]
            true
          end.returns(FakeResponse.new)

          subject.indices.put_alias :index => 'foo', :name => 'bar', :body => { :filter => 'foo' }
        end

      end

    end
  end
end
