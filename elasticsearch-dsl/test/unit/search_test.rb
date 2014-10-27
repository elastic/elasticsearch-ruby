require 'test_helper'

module Elasticsearch
  module Test
    class SearchTest < ::Test::Unit::TestCase
      subject { Elasticsearch::DSL::Search::Search.new }

      context "The Search module" do
        should "have the search method" do
          class DummySearchReceiver
            include Elasticsearch::DSL::Search
          end

          assert_instance_of Elasticsearch::DSL::Search::Search, DummySearchReceiver.new.search
        end
      end

      context "The Search class" do

        should "take the query as a literal value" do
          subject.query foo: 'bar'
          assert_equal({query: { foo: 'bar' }}, subject.to_hash)
        end

        should "take the query as a block" do
          Elasticsearch::DSL::Search::Query.expects(:new).returns({foo: 'bar'})
          subject.query do; end
          assert_equal({query: { foo: 'bar' }}, subject.to_hash)
        end

        should "allow chaining" do
          assert_instance_of Elasticsearch::DSL::Search::Search, subject.query(:foo)
          assert_instance_of Elasticsearch::DSL::Search::Search, subject.query(:foo).query(:bar)
        end

        should "be converted to hash" do
          assert_equal({}, subject.to_hash)

          subject.query foo: 'bar'
          assert_equal({query: { foo: 'bar' }}, subject.to_hash)
        end

      end
    end
  end
end
