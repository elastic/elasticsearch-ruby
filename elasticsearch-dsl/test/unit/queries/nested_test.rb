require 'test_helper'

module Elasticsearch
  module Test
    module Queries
      class NestedTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Queries

        context "Nested query" do
          subject { Nested.new }

          should "be converted to a Hash" do
            assert_equal({ nested: {} }, subject.to_hash)
          end

          should "have option methods" do
            subject = Nested.new

            subject.path 'bar'
            subject.score_mode 'bar'
            subject.query 'bar'

            assert_equal %w[ path query score_mode ],
                         subject.to_hash[:nested].keys.map(&:to_s).sort
            assert_equal 'bar', subject.to_hash[:nested][:path]
          end

          should "take the query as a Hash" do
            subject = Nested.new
            subject.path 'bar'
            subject.query match: { foo: 'bar' }

            assert_equal({nested: { path: 'bar', query: { match: { foo: 'bar' } } } }, subject.to_hash)
          end

          should "take a block" do
            subject = Nested.new do
              path 'bar'
              query do
                match foo: 'bar'
              end
            end

            assert_equal({nested: { path: 'bar', query: { match: { foo: 'bar' } } } }, subject.to_hash)
          end
        end
      end
    end
  end
end
