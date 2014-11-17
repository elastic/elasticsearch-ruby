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

        context "with query" do
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

        context "with filter" do
          should "take the filter as a literal value" do
            subject.filter foo: 'bar'
            assert_equal({filter: { foo: 'bar' }}, subject.to_hash)
          end

          should "take the filter as a block" do
            Elasticsearch::DSL::Search::Filter.expects(:new).returns({foo: 'bar'})
            subject.filter do; end
            assert_equal({filter: { foo: 'bar' }}, subject.to_hash)
          end

          should "allow chaining" do
            assert_instance_of Elasticsearch::DSL::Search::Search, subject.filter(:foo)
            assert_instance_of Elasticsearch::DSL::Search::Search, subject.filter(:foo).filter(:bar)
          end

          should "be converted to hash" do
            assert_equal({}, subject.to_hash)

            subject.filter foo: 'bar'
            assert_equal({filter: { foo: 'bar' }}, subject.to_hash)
          end
        end

        context "with post_filter" do
          should "take the filter as a literal value" do
            subject.post_filter foo: 'bar'
            assert_equal({post_filter: { foo: 'bar' }}, subject.to_hash)
          end

          should "take the filter as a block" do
            Elasticsearch::DSL::Search::Filter.expects(:new).returns({foo: 'bar'})
            subject.post_filter do; end
            assert_equal({post_filter: { foo: 'bar' }}, subject.to_hash)
          end

          should "allow chaining" do
            assert_instance_of Elasticsearch::DSL::Search::Search, subject.post_filter(:foo)
            assert_instance_of Elasticsearch::DSL::Search::Search, subject.post_filter(:foo).post_filter(:bar)
          end

          should "be converted to hash" do
            assert_equal({}, subject.to_hash)

            subject.post_filter foo: 'bar'
            assert_equal({post_filter: { foo: 'bar' }}, subject.to_hash)
          end
        end

        context "with aggregations" do
          should "take the aggregation as a literal value" do
            subject.aggregation :foo, terms: 'bar'
            assert_equal({aggregations: { foo: { terms: "bar" } } }, subject.to_hash)
          end

          should "take the aggregation as a block" do
            Elasticsearch::DSL::Search::Aggregation.expects(:new).returns({tam: 'tam'})
            subject.aggregation :foo do; end
            assert_equal({aggregations: { foo: { tam: 'tam' } } }, subject.to_hash)
          end

          should "allow chaining" do
            assert_instance_of Elasticsearch::DSL::Search::Search, subject.aggregation(:foo)
            assert_instance_of Elasticsearch::DSL::Search::Search, subject.aggregation(:foo).aggregation(:bar)
          end

          should "be converted to hash" do
            assert_equal({}, subject.to_hash)

            subject.post_filter foo: 'bar'
            assert_equal({post_filter: { foo: 'bar' }}, subject.to_hash)
          end
        end

        context "with sorting" do
          should "be converted to hash" do
            subject.sort :foo
            assert_equal( { sort: [ :foo ] }, subject.to_hash )
          end
        end

      end
    end
  end
end
