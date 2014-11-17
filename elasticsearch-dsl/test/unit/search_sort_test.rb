require 'test_helper'

module Elasticsearch
  module Test
    class SearchSortTest < ::Test::Unit::TestCase
      subject { Elasticsearch::DSL::Search::Sort.new }

      context "Search sort" do

        should "add a single field" do
          subject = Elasticsearch::DSL::Search::Sort.new :foo
          assert_equal( [:foo], subject.to_hash )
        end

        should "add multiple fields" do
          subject = Elasticsearch::DSL::Search::Sort.new [:foo, :bar]
          assert_equal( [:foo, :bar], subject.to_hash )
        end

        should "add a field with options" do
          subject = Elasticsearch::DSL::Search::Sort.new foo: { order: 'desc', mode: 'avg' }
          assert_equal( [ { foo: { order: 'desc', mode: 'avg' } } ], subject.to_hash )
        end

        should "add fields with the DSL method" do
          subject = Elasticsearch::DSL::Search::Sort.new do
            by :foo
            by :bar, order: 'desc'
          end

          assert_equal(
            [
              :foo,
              { bar: { order: 'desc' } },
            ], subject.to_hash )
        end
      end
    end
  end
end
