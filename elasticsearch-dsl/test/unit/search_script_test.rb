require 'test_helper'

module Elasticsearch
  module Test
    class SearchScriptTest < ::Elasticsearch::Test::UnitTestCase
      subject { Elasticsearch::DSL::Search::Script.new }

      context "Search sort" do

        should "add a single field" do
          subject = Elasticsearch::DSL::Search::Script.new :params
          assert_equal( [:params], subject.to_hash )
        end

        should "add multiple fields" do
          subject = Elasticsearch::DSL::Search::Script.new [:params, :inline]
          assert_equal( [:params, :inline], subject.to_hash )
        end

        should "add a field with options" do
          subject = Elasticsearch::DSL::Search::Script.new script: { params: 'hi', inline: 'test' }
          assert_equal( [ { script: { params: 'hi', inline: 'test' } } ], subject.to_hash )
        end

        should "add fields with the DSL method" do
          subject = Elasticsearch::DSL::Search::Script.new do
            inline: "bloop._source['test'] = bleep.test; "
            params: 'test'
          end

          assert_equal(
            [
              { inline: { "bloop._source['test'] = bleep.test; " },
              { params: { 'test' } },
            ], subject.to_hash )
        end

        should "be empty" do
          subject = Elasticsearch::DSL::Search::Script.new
          assert_equal subject.empty?, true
        end

        should "not be empty" do
          subject = Elasticsearch::DSL::Search::Script.new params: { 'test' }
          assert_equal subject.empty?, false
        end

        context "#to_hash" do
          should "not duplicate values when defined by arguments" do
            subject = Elasticsearch::DSL::Search::Script.new params: { 'test' }
            assert_equal(subject.to_hash, subject.to_hash)
          end

          should "not duplicate values when defined by a block" do
            subject = Elasticsearch::DSL::Search::Script.new do
              params: 'test'
            end

            assert_equal(subject.to_hash, subject.to_hash)
          end
        end
      end
    end
  end
end
